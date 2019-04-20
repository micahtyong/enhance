//
//  PushupMLVC.swift
//  Enhance
//
//  Created by Micah Yong on 4/18/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit
import AVKit
import Vision
import PopupDialog

class PushupMLVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var activity : Pushup = Pushup(upTo: 10)
    var skeleton : ActivitySkeleton = ActivitySkeleton()
    var currTime : Int = 0
    var currPushup : Int = 0
    var confidenceLevel : Double = 92.4
    weak var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupModel() {
        let captureSession = AVCaptureSession()
        
        guard let captureDevice = defaultCamera() else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer : CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else { return }
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
            guard let firstObservation = results.first else { return }
            
            print(firstObservation.identifier, firstObservation.confidence)
            
            DispatchQueue.main.async {
//                self.identifierLabel.text = "\(firstObservation.identifier) \(firstObservation.confidence * 100)"
            }
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    func setupUI() {
        view.backgroundColor = .clear
        setupSkeleton()
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
    
    @objc func popUpOptions(_ sender:UIButton) {
        onboardingPopup()
    }
    
    @objc func beginML(_ sender:UIButton) {
        self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        skeleton.setupCounterLabel()
//        setupModel()
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
        } else {
            incrementCounter()
        }
        currTime += 1
    }
    
    func incrementCounter() {
        if currPushup <= activity.max {
            skeleton.setCounterText(to: "\(currPushup)")
            currPushup += 1
        } else {
            timer?.invalidate()
            skeleton.setDone()
            skeleton.playButton.removeTarget(nil, action: nil, for: .allEvents)
            skeleton.playButton.addTarget(self, action: #selector(finishingOptions), for: .touchUpInside)
        }
    }
    
    func onboardingPopup() {
        // Prepare the popup assets
        let title = "HOW TO PLAY"
        let message = "Rotate your phone clockwise and prop phone ten feet away form you.\nPerform ten pushups in proper form. \nUse the color and counter on the screen to guide you! Green means good, red means fix your form."
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
        // Prepare the popup assets
        let title = "SUCCESS"
        let message = "You successfully completed \(activity.max) with a confidence level of \(confidenceLevel)%.\nYour final score is: \(confidenceLevel / 10)."
        let image = UIImage(named: "pushupDemo1")
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
    
    @objc func finishingOptions(_ sender:UIButton) {
        finishingPopup()
    }
    
    @objc func endML(_ sender:UIButton) {
        dismiss(animated: true, completion: nil)
        let vc = TrainingVC() // will later change / generalize based on vc in the struct
        vc.hero.isEnabled = true
        vc.hero.modalAnimationType = .selectBy(presenting: .zoomSlide(direction: .down), dismissing: .zoomOut)
        self.present(vc, animated: true, completion: nil)
    }
    
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
