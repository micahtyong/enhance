//
//  PlanksMLUIVC.swift
//  Enhance
//
//  Created by Micah Yong on 5/5/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit
import CoreML
import AVKit
import PopupDialog

extension PlanksMLVC2 {

    // UI
    func setupUI() {
        view.backgroundColor = .clear
        setupSkeleton()
        setupBackButton()
        setupImageView()
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
    
    @objc func testPhotoCapture(_ sender:UIButton) {
        self.frameReady = true
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
    
    func onboardingPopup() {
        // Prepare the popup assets
        let title = "HOW TO PLAY"
        let message = "Place your phone a few feet in front of you and get into plank form.\nHold that form for \(activity.max) seconds.\nUse the color and counter on the screen to guide you! Green means good, red means fix your form."
        let image = UIImage(named: "plankForm1")
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
    
    @objc func finishingOptions(_ sender:UIButton) {
        finishingPopup()
    }
    
    func finishingPopup() {
        let strengthPoints : Int = activity.max
        let totalPoints : Double = activity.showConfidence() / 10.0
        updateUser(energyPoints : totalPoints)
        // Prepare the popup assets
        let title = "SUCCESS"
        let message = "You successfully held a plank for \(strengthPoints) seconds with a confidence level of \(activity.showConfidence())%.\nYour final score is: \(totalPoints)."
        let image = UIImage(named: "planks2")
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
    
}
