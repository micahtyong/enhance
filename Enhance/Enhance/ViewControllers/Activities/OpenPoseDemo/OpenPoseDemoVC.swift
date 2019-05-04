//
//  OpenPoseDemoVC.swift
//  Enhance
//
//  Created by Micah Yong on 5/3/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit
import CoreML
import AVKit
import Vision
import PopupDialog
import Firebase
import Hero

class OpenPoseDemoVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var skeleton : ActivitySkeleton = ActivitySkeleton()
    let backButton : BackButton = BackButton()
    let imageView : UIImageView = UIImageView()
    
    let captureSession : AVCaptureSession = AVCaptureSession()
    var previewLayer : CALayer!
    var captureDevice : AVCaptureDevice!
    var frameReady : Bool = false
    
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
        
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
        
        captureSession.commitConfiguration()
        
        let queue = DispatchQueue(label: "captureActivity")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
    }
    
    // MARK: - CoreML Properties
    
    let model = MobileOpenPose()
    let ImageWidth = 368
    let ImageHeight = 368
    
    // MARK: - Capture Output handles CoreML
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if frameReady {
            frameReady = false
            // PROCESSED IMAGE FROM SAMPLE BUFFER (STEP 1)
            if let image = self.getImageFromSampleBuffer(buffer: sampleBuffer) {
                
                DispatchQueue.main.async {
                    // EXTRACT JOINTS IMAGE (STEP 2)
                    if let jointsImage = self.runCoreML(image) {
                        // TEMPORARY DISPLAY
                        let photoVC = PhotoDisplayVC()
                        photoVC.setImageTo(jointsImage)
                        
                        self.present(photoVC, animated: true, completion: {
                            self.stopCaptureSession()
                        })

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
    
    // MARK: - Measure amount of time elapsed in classification process
    
    func measure <T> (_ f: @autoclosure () -> T) -> (result: T, duration: String) {
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = f()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        return (result, "Elapsed time is \(timeElapsed) seconds.")
    }
    
    // UX
    @objc func testPhotoCapture(_ sender:UIButton) {
        self.frameReady = true
    }
    
    // UI
    func setupUI() {
        view.backgroundColor = .clear
        setupSkeleton()
        setupBackButton()
        setupImageView()
    }
    
    func setupSkeleton() {
        skeleton.playButton.addTarget(self, action: #selector(testPhotoCapture), for: .touchUpInside)
        
        self.view.addSubview(skeleton)
        
        skeleton.translatesAutoresizingMaskIntoConstraints = false
        skeleton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        skeleton.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        skeleton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        skeleton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func setupImageView() {
        imageView.backgroundColor = .clear
        
        self.view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: CGFloat(ImageWidth)).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: CGFloat(ImageHeight)).isActive = true
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
}
