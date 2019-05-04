//
//  PushupMLVC2.swift
//  Enhance
//
//  Created by Micah Yong on 5/2/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit
import CoreML
import AVKit
import Vision
import PopupDialog
import Firebase
import Hero

class PushupMLVC2: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var user : User = Enhance.user
    let ref : DatabaseReference! = Database.database().reference()
    
    var activity : VisionActivity = VisionActivity(upTo: 10)
    var skeleton : ActivitySkeleton = ActivitySkeleton()
    let backButton : BackButton = BackButton()
    let imageView : UIImageView = UIImageView()
    
    let captureSession : AVCaptureSession = AVCaptureSession()
    var previewLayer : CALayer!
    var captureDevice : AVCaptureDevice!
    var frameReady : Bool = false
    
    var currTime : Int = 0
    weak var timer: Timer?
    
    var screenWidth = 0
    var screenHeight = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCamera()
        setupUI()
    }
    
    // Mark: - Methods to set up camera
    
    func setupCamera() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .front).devices
        captureDevice = availableDevices.first
        beginSession()
    }
    
    func beginSession() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureDeviceInput)
        } catch {
            print(error.localizedDescription)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer = previewLayer
        self.view.layer.addSublayer(self.previewLayer)
        self.previewLayer.frame = self.view.layer.frame
        captureSession.startRunning()
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value:kCVPixelFormatType_32BGRA)] as [String : Any]
        //        dataOutput.alwaysDiscardsLateVideoFrames = true
        
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
        
        captureSession.commitConfiguration()
        
        let queue = DispatchQueue(label: "captureActivity")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
    }

    // MARK: - CoreML Properties
    
    let model = MobileOpenPose()
    let pushupModel = PushupsModelB()
    let ImageWidth = 368
    let ImageHeight = 368
    
    // MARK: - Capture Output handles CoreML
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if modelIsActive() {
            frameReady = false
            // PROCESSED IMAGE FROM SAMPLE BUFFER (STEP 1)
            if let image = self.getImageFromSampleBuffer(buffer: sampleBuffer) {
                
                DispatchQueue.main.async {
                    // EXTRACT JOINTS IMAGE (STEP 2)
                    if let jointsImage = self.runCoreML(image) {
                        // PROCESS JOINTS IN PUSHUPS MODEL (STEP 3)
                        self.runThroughModel(jointsImage)
                    }
                }
            
            }
        }
    }
    
    // MARK: - Step 1; Convert imageBuffer to UIImage
    
    func getImageFromSampleBuffer(buffer:CMSampleBuffer) -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            
            if let image = context.createCGImage(ciImage, from: imageRect) {
                let image : UIImage = UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
                return image.cropToBounds(image: image, width: ImageWidth, height: ImageHeight)
            }
        }
        return nil
    }
    
    // MARK: - Step 2; Extract joints image
    
    func runCoreML(_ image: UIImage) -> UIImage? {
        
        if let pixelBuffer = image.pixelBuffer(width: ImageWidth, height: ImageHeight) {
            
            let startTime = CFAbsoluteTimeGetCurrent()
            if let prediction = try? model.prediction(image: pixelBuffer) {
                
                let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
                print("coreml elapsed for \(timeElapsed) seconds")
                
                let predictionOutput = prediction.net_output
                let length = predictionOutput.count
                print(predictionOutput)
                
                let doublePointer =  predictionOutput.dataPointer.bindMemory(to: Double.self, capacity: length)
                let doubleBuffer = UnsafeBufferPointer(start: doublePointer, count: length)
                let mm = Array(doubleBuffer)
                
                // Delete Beizer paths of previous image
                imageView.layer.sublayers = []
                // Draw new lines
                if let jointsImage = drawLines(mm) {
                    return jointsImage
                }
            }
        }
        return nil
    }
    
    // MARK: - Step 3; Process joints in pushups model
    
    func runThroughModel(_ jointsImage : UIImage) {
        
        guard let model = try? VNCoreMLModel(for: PushupsModelB().model) else { return }
        
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
            guard let firstObservation = results.first else { return }
            
            print(firstObservation.identifier, firstObservation.confidence)
            
            DispatchQueue.main.async {
                if (firstObservation.identifier == "goodPushups") {
                    print("Good pushup!")
                    self.skeleton.setGood()
                    self.activity.calibrateConfidence(isGood : true)
                } else if (firstObservation.identifier == "badPushups") {
                    print("Bad pushup!")
                    self.skeleton.setBad()
                    self.activity.calibrateConfidence(isGood : false)
                }
            }
        }
        let jointsCIImage : CIImage = toCIImage(image: jointsImage)
        try? VNImageRequestHandler(ciImage: jointsCIImage, options: [:]).perform([request])
        
    }
    
    func toCIImage(image: UIImage) -> CIImage {
        return image.ciImage ?? CIImage(cgImage: image.cgImage!)
    }
    
    // MARK: - Helper Methods
    
    // MARK: - Stop camera from running
    
    func stopCaptureSession () {
        self.captureSession.stopRunning()
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                self.captureSession.removeInput(input)
            }
        }
    }
    
    // MARK: - Drawing; helper for Step 2
    
    func drawLines(_ mm: Array<Double>) -> UIImage? {
        
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
            return renderedImage
        }
        
        return nil
    }
    
    // MARK: - Add image to Library
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("no error")
        }
    }
    
    // MARK: - Measure amount of time elapsed in classification process
    
    func measure <T> (_ f: @autoclosure () -> T) -> (result: T, duration: String) {
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = f()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        return (result, "Elapsed time is \(timeElapsed) seconds.")
    }
    
    // UX
    
    // Mark: - Time constants
    
    let readyTime : Int = 1
    let setTime : Int = 2
    let goTime : Int = 3
    
    // Mark: - Condition for image classification
    
    func modelIsActive() -> Bool {
        return (currTime >= (goTime * 2)) && !activity.isDone() && frameReady
    }
    
    // Mark: - Firebase methods
    
    func updateUser(energyPoints : Double, activityAmount : Int) {
        Enhance.user.addToTotal(amount : energyPoints)
        Enhance.user.addToStrength(amount: Double(activityAmount))
        updateDatabase()
    }
    
    func updateDatabase() {
        self.ref.child("Users").child(user.deviceID).setValue(["Name" : Enhance.user.name, "Total" : round(Enhance.user.energyPoints), "Strength" : Enhance.user.strengthTotal, "Stamina" : Enhance.user.staminaTotal, "Core" : Enhance.user.staminaTotal])
    }
    
    // Mark: - Begin activity
    
    @objc func beginML(_ sender:UIButton) {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        skeleton.setupCounterLabel()
    }
    
    // Mark: - Function that fires every second
    
    @objc func fireTimer() {
        skeleton.bounceCounter()
        if currTime < readyTime * 2 { // READY
            skeleton.setCounterText(to: activity.ready())
            skeleton.setBad()
        } else if currTime < setTime * 2 { // SET
            skeleton.setCounterText(to: activity.set())
        } else if currTime < goTime * 2 { // GO
            skeleton.setCounterText(to: activity.go())
            skeleton.setGood()
            frameReady = true
        } else {
            incrementCounter()
        }
        currTime += 1
    }
    
    // Mark: - Handles activity score updates
    
    func incrementCounter() {
        // STEP 1: UPDATED CURR IN ACTIVITY
        if (currTime % 2 == 0) {
            activity.increment()
        }
        // STEP 2: CHECK IF DONE; PERFORM RESPECTIVE ACTIONS
        if !activity.isDone() {
            skeleton.setCounterText(to: "\(activity.curr)")
            frameReady = true
        } else {
            timer?.invalidate()
            skeleton.setDone()
            skeleton.playButton.removeTarget(nil, action: nil, for: .allEvents)
            skeleton.playButton.addTarget(self, action: #selector(finishingOptions), for: .touchUpInside)
        }
    }
    
    // Mark: - Transition back to home page
    
    @objc func endML(_ sender:UIButton) {
        dismiss(animated: true, completion: nil)
        let vc = TabsVC()
        vc.hero.isEnabled = true
        vc.hero.modalAnimationType = .selectBy(presenting: .zoomSlide(direction: .down), dismissing: .zoomOut)
        self.present(vc, animated: true, completion: nil)
    }

}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

extension UIImage {
    func imageWithLayer(layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.isOpaque, 0.0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return img
    }
}

//    func setupCamera() {
//        captureSession.sessionPreset = AVCaptureSession.Preset.photo
//
//        let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .front).devices
//        captureDevice = availableDevices.first
//        beginSession()
//    }


//    func beginSession() {
//        do {
//            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
//            captureSession.addInput(captureDeviceInput)
//        } catch {
//            print(error.localizedDescription)
//        }
//
//        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        self.previewLayer = previewLayer
//        self.view.layer.addSublayer(self.previewLayer)
//        self.previewLayer.frame = self.view.layer.frame
//        captureSession.startRunning()
//
//        let dataOutput = AVCaptureVideoDataOutput()
//        dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value:kCVPixelFormatType_32BGRA)] as [String : Any]
////        dataOutput.alwaysDiscardsLateVideoFrames = true
//
//        if captureSession.canAddOutput(dataOutput) {
//            captureSession.addOutput(dataOutput)
//        }
//
//        captureSession.commitConfiguration()
//
//        let queue = DispatchQueue(label: "captureActivity")
//        dataOutput.setSampleBufferDelegate(self, queue: queue)
//    }

//                    if let jointsImage = self.runCoreML(image) {
//
////                        UIImageWriteToSavedPhotosAlbum(jointsImage, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
//
//                        // TEMPORARY DISPLAY
//                        let photoVC = PhotoDisplayVC()
//                        photoVC.setImageTo(jointsImage)
//
////                         Run through next coreML model
//                        self.runThroughModel(jointsImage, photoVC: photoVC)
//
////                         testing model
////                        if outcome {
////                            photoVC.setBackgroundTo(UIColor.green)
////                            print("good pushup")
////                        } else {
////                            photoVC.setBackgroundTo(UIColor.red)
////                            print("bad pushup")
////                        }
//
//                        self.present(photoVC, animated: true, completion: {
//                            self.stopCaptureSession()
//                        })
//                    }


