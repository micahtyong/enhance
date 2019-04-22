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
    
    var activity : VisionActivity = VisionActivity(upTo: 10)
    var skeleton : ActivitySkeleton = ActivitySkeleton()
    let captureSession: AVCaptureSession = AVCaptureSession()
    let backButton : BackButton = BackButton()
    
    var currTime : Int = 0
    weak var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupUI()
    }
    
    func setupCamera() {
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
        
        if modelIsActive() {
            guard let pixelBuffer : CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            
            guard let model = try? VNCoreMLModel(for: PushupsA().model) else { return }
            let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
                guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
                guard let firstObservation = results.first else { return }
                
                print(firstObservation.identifier, firstObservation.confidence)
                
                DispatchQueue.main.async {
                    if (firstObservation.identifier == "goodPushups") {
                        self.skeleton.setGood()
                        self.activity.calibrateConfidence(isGood : true)
                    } else {
                        self.skeleton.setBad()
                        self.activity.calibrateConfidence(isGood : false)
                    }
                }
            }
            try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        }

    }
    
    func modelIsActive() -> Bool {
        return currTime >= 3 && !activity.isDone()
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
        } else {
            incrementCounter()
        }
        currTime += 1
    }
    
    func incrementCounter() {
        if !activity.isDone() {
            skeleton.setCounterText(to: "\(activity.curr)")
            activity.increment()
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
        // Prepare the popup assets
        let title = "SUCCESS"
        let message = "You successfully completed \(activity.max) pushups with a confidence level of \(activity.showConfidence())%.\nYour final score is: \(activity.showConfidence() / 10.0)."
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
