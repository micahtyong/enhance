//
//  PushupMLVC.swift
//  Enhance
//
//  Created by Micah Yong on 4/18/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit
import CoreML
import AVKit
import Vision
import PopupDialog
import Firebase

class PushupMLVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var user : User = Enhance.user
    let ref : DatabaseReference! = Database.database().reference()
    
    var activity : VisionActivity = VisionActivity(upTo: 10)
    var skeleton : ActivitySkeleton = ActivitySkeleton()
    let backButton : BackButton = BackButton()
    
    let captureSession : AVCaptureSession = AVCaptureSession()
    
    var currTime : Int = 0
    weak var timer: Timer?
    var modelReady : Bool = false
    
    var screenWidth = 0
    var screenHeight = 0
    
    let imageView : UIImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupUI()
    }
    
    // UX
    
    func updateUser(energyPoints : Double, activityAmount : Int) {
        Enhance.user.addToTotal(amount : energyPoints)
        Enhance.user.addToStrength(amount: Double(activityAmount))
        updateDatabase()
    }
    
    func updateDatabase() {
        self.ref.child("Users").child(user.deviceID).setValue(["Name" : Enhance.user.name, "Total" : round(Enhance.user.energyPoints), "Strength" : Enhance.user.strengthTotal, "Stamina" : Enhance.user.staminaTotal, "Core" : Enhance.user.staminaTotal])
    }
    
    @objc func popUpOptions(_ sender:UIButton) {
        onboardingPopup()
    }
    
    @objc func beginML(_ sender:UIButton) {
        self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        skeleton.setupCounterLabel()
    }
    
    @objc func fireTimer() {
        skeleton.bounceCounter()
        if currTime < 1 { // READY
            skeleton.setCounterText(to: activity.ready())
            skeleton.setBad()
        } else if currTime < 2 { // SET
            skeleton.setCounterText(to: activity.set())
        } else if currTime < 3 { // GO
            skeleton.setCounterText(to: activity.go())
            skeleton.setGood()
            modelReady = true
        } else {
            incrementCounter()
        }
        currTime += 1
    }
    
    func incrementCounter() {
        if !activity.isDone() {
            skeleton.setCounterText(to: "\(activity.curr)")
            modelReady = true
            activity.increment()
        } else {
            timer?.invalidate()
            skeleton.setDone()
            skeleton.playButton.removeTarget(nil, action: nil, for: .allEvents)
            skeleton.playButton.addTarget(self, action: #selector(finishingOptions), for: .touchUpInside)
        }
    }
    
    @objc func finishingOptions(_ sender:UIButton) {
        finishingPopup()
    }
    
    @objc func endML(_ sender:UIButton) {
        dismiss(animated: true, completion: nil)
        let vc = TabsVC() // will later change / generalize based on vc in the struct
        vc.hero.isEnabled = true
        vc.hero.modalAnimationType = .selectBy(presenting: .zoomSlide(direction: .down), dismissing: .zoomOut)
        self.present(vc, animated: true, completion: nil)
    }
    
    // COMPUTER VISION
    
    func setupCamera() {
        let captureSession = AVCaptureSession()
        
        guard let captureDevice = defaultCamera() else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.connection?.videoOrientation = .portrait
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        // SET IMAGEVIEW HERE
        setupImageView()
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
    }
    
    
    // MARK: - CoreML Properties
    
    let model = MobileOpenPose()
    let ImageWidth = 368
    let ImageHeight = 368
    
    // MARK: - Initial CoreML Methods
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        if modelIsActive() {
            guard let pixelBuffer : CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            guard let ciimage : CIImage = CIImage(cvPixelBuffer: pixelBuffer) else { return }
            guard let image : UIImage = self.convert(cmage: ciimage) else { return }
            guard let croppedPixelBuffer = image.pixelBuffer(width: ImageWidth, height: ImageHeight) else { return }
            
            let startTime = CFAbsoluteTimeGetCurrent()
            if let prediction = try? model.prediction(image: croppedPixelBuffer) {
                
                let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
                print("coreml elapsed for \(timeElapsed) seconds")
                
                // Display new image
                imageView.image = UIImage(pixelBuffer: croppedPixelBuffer)
                
                let predictionOutput = prediction.net_output
                let length = predictionOutput.count
                print(predictionOutput)
                
                let doublePointer =  predictionOutput.dataPointer.bindMemory(to: Double.self, capacity: length)
                let doubleBuffer = UnsafeBufferPointer(start: doublePointer, count: length)
                let mm = Array(doubleBuffer)
                
                // Delete Beizer paths of previous image
                imageView.layer.sublayers = []
                // Draw new lines
                drawLines(mm)
            }
        }
        modelReady = false
        
    }
    
    // Convert CIImage to CGImage and crop it
    func convert(cmage : CIImage) -> UIImage {
        let context : CIContext = CIContext.init(options: nil)
        let cgImage : CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image : UIImage = UIImage.init(cgImage: cgImage)
        return image.cropToBounds(image: image, width: ImageWidth, height: ImageHeight)
    }
    
    // MARK: - CoreML CV Methods
    func runCoreML(_ image: UIImage) {
        
        if let pixelBuffer = image.pixelBuffer(width: ImageWidth, height: ImageHeight) {
            
            let startTime = CFAbsoluteTimeGetCurrent()
            if let prediction = try? model.prediction(image: pixelBuffer) {
                
                let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
                print("coreml elapsed for \(timeElapsed) seconds")
                
                // Display new image
                imageView.image = UIImage(pixelBuffer: pixelBuffer)
                
                let predictionOutput = prediction.net_output
                let length = predictionOutput.count
                print(predictionOutput)
                
                let doublePointer =  predictionOutput.dataPointer.bindMemory(to: Double.self, capacity: length)
                let doubleBuffer = UnsafeBufferPointer(start: doublePointer, count: length)
                let mm = Array(doubleBuffer)
                
                // Delete Beizer paths of previous image
                imageView.layer.sublayers = []
                // Draw new lines
                drawLines(mm)
            }
        }
    }
    
    func modelIsActive() -> Bool {
        return currTime >= 3 && !activity.isDone() && modelReady
    }
    
    // UI
    
    func setupImageView() {
        imageView.backgroundColor = .clear
        
        self.view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: CGFloat(ImageWidth)).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: CGFloat(ImageHeight)).isActive = true
    }
    
    func setupUI() {
        view.backgroundColor = .clear
        setupSkeleton()
        setupBackButton()
    }
    
    func setupSkeleton() {
        skeleton.playButton.addTarget(self, action: #selector(popUpOptions), for: .touchUpInside)
        
        self.view.addSubview(skeleton)
        
        skeleton.translatesAutoresizingMaskIntoConstraints = false
        skeleton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        skeleton.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        skeleton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        skeleton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func onboardingPopup() {
        // Prepare the popup assets
        let title = "HOW TO PLAY"
        let message = "Rotate your phone counter-clockwise and prop phone ten feet away form you.\nPerform \(activity.max) pushups in proper form. \nUse the color and counter on the screen to guide you! Green means good, red means fix your form."
        let image = UIImage(named: "pushupDemo1")
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image)
        // Create buttons
        let cancelButton = CancelButton(title: "CANCEL") {
            print("You canceled the dialog.")
        }
        let startButton = DefaultButton(title: "PLAY", height: 60) {
            print("Let's go!")
        }
        startButton.addTarget(self, action: #selector(beginML), for: .touchUpInside)
        popup.addButtons([cancelButton, startButton])
        self.present(popup, animated: true, completion: nil)
    }
    
    func finishingPopup() {
        let strengthPoints : Int = activity.max
        let totalPoints : Double = activity.showConfidence() / 10.0
        updateUser(energyPoints : totalPoints, activityAmount : strengthPoints)
        // Prepare the popup assets
        let title = "SUCCESS"
        let message = "You successfully completed \(strengthPoints) pushups with a confidence level of \(activity.showConfidence())%.\nYour final score is: \(totalPoints)."
        let image = UIImage(named: "openPose1")
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image)
        // Create buttons
        let finishButton = DefaultButton(title: "FINISH", height: 60) {
            print("Finish!")
        }
        finishButton.addTarget(self, action: #selector(endML), for: .touchUpInside)
        popup.addButtons([finishButton])
        self.present(popup, animated: true, completion: nil)
    }
    
    func setupBackButton() {
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        self.view.addSubview(backButton)
        
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        backButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func goBack(_ sender:UIButton) {
        sender.pulse()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Drawing
    
    func drawLines(_ mm: Array<Double>) {
        
        let poseEstimator = PoseEstimator(ImageWidth,ImageHeight)
        
        let res = measure(poseEstimator.estimate(mm))
        let humans = res.result;
        print("estimate \(res.duration)")
        
        var keypoint = [Int32]()
        var pos = [CGPoint]()
        for human in humans {
            var centers = [Int: CGPoint]()
            for i in 0...CocoPart.Background.rawValue {
                if human.bodyParts.keys.firstIndex(of: i) == nil {
                    continue
                }
                let bodyPart = human.bodyParts[i]!
                centers[i] = CGPoint(x: bodyPart.x, y: bodyPart.y)
            }
            
            for (pairOrder, (pair1,pair2)) in CocoPairsRender.enumerated() {
                
                if human.bodyParts.keys.firstIndex(of: pair1) == nil || human.bodyParts.keys.firstIndex(of: pair2) == nil {
                    continue
                }
                if centers.index(forKey: pair1) != nil && centers.index(forKey: pair2) != nil{
                    keypoint.append(Int32(pairOrder))
                    pos.append(centers[pair1]!)
                    pos.append(centers[pair2]!)
                }
            }
        }
        
        let openCVWrapper = OpenCVWrapper()
        let drawLayer = CALayer()
        drawLayer.frame = imageView.bounds
        drawLayer.opacity = 0.6
        drawLayer.masksToBounds = true
        if let renderedImage : UIImage = openCVWrapper.renderKeyPoint(imageView.frame,
                                                            keypoint: &keypoint,
                                                            keypoint_size: Int32(keypoint.count),
                                                            pos: &pos) {
            drawLayer.contents = renderedImage.cgImage
        }
        
        imageView.layer.addSublayer(drawLayer)
        
    }
    // MARK: - Help Methods
    
    func measure <T> (_ f: @autoclosure () -> T) -> (result: T, duration: String) {
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = f()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        return (result, "Elapsed time is \(timeElapsed) seconds.")
    }

}

extension UIViewController {
    func defaultCamera() -> AVCaptureDevice? {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: AVMediaType.video, position: .front) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) {
            return device
        } else {
            return nil
        }
    }
}

extension UIImage {
    func cropToBounds(image: UIImage, width: Int, height: Int) -> UIImage {
        
        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
}
