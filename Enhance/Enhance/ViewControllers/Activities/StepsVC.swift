//
//  StepsVC.swift
//  Enhance
//
//  Created by Micah Yong on 4/21/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit
import PopupDialog

class StepsVC: UIViewController {
    
    var activity : PedometerActivity = PedometerActivity(upTo: 1)
    var skeleton : ActivitySkeleton = ActivitySkeleton()
    var pedometer : PedometerView = PedometerView()
    let backButton : BackButton = BackButton()
    
    let miles = "miles"
    let kilo = "kilometers"
    
    var currTime : Int = 0
    weak var timer: Timer?
    
    var screenHeight : CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        screenHeight = self.screenSize().size.height
        setupSkeleton()
        setupBackButton()
    }
    
    func setupPedometer() {
        self.view.addSubview(pedometer)
        
        pedometer.translatesAutoresizingMaskIntoConstraints = false
        pedometer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pedometer.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.21 * screenHeight).isActive = true
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
        let message = "Step outside or find a nice space where you can do some jogging!\nIn \(activity.maxTime) minutes, take as many steps as you can.\nBonus points for every quarter-mile completed!"
        let image = UIImage(named: "runningDemo2")
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image)
        // Create buttons
        let cancelButton = CancelButton(title: "CANCEL") {
            print("You canceled the dialog.")
        }
        let startButton = DefaultButton(title: "PLAY", height: 60) {
            print("Let's go!")
        }
        startButton.addTarget(self, action: #selector(beginPedometer), for: .touchUpInside)
        popup.addButtons([cancelButton, startButton])
        self.present(popup, animated: true, completion: nil)
    }
    
    @objc func beginPedometer(_ sender:UIButton) {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        setupPedometer()
    }
    
    @objc func fireTimer() {
        skeleton.bounceCounter()
        if currTime < 1 { // READY
            pedometer.setMainText(to: "Ready?")
        } else if currTime < 2 { // SET
            pedometer.setMainText(to: "Set?")
        } else if currTime < 3 { // GO
            pedometer.setMainText(to: "Go!")
            pedometer.resetTime()
            activity.startUpdating()
        } else {
            pedometer.calibrateTime()
            checkTimer()
        }
        currTime += 1
    }
    
    func configurePedometer() {
        activity.incrementTime()
        pedometer.setSteps(to: activity.showSteps())
        pedometer.setDistance(to: activity.showDistance(in: miles), in: miles)
    }
    
    func checkTimer() {
        if !activity.isDone() {
            configurePedometer()
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
    
    func finishingPopup() {
        // Prepare the popup assets
        let title = "SUCCESS"
        let message = "You successfully completed \(activity.maxTime) minutes of running with a total of \(activity.showDistance(in: miles)) miles.\nYour final score is: \(activity.showDistance(in: miles) / 10.0)."
        let image = UIImage(named: "runningDemo3")
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
    
    @objc func endML(_ sender:UIButton) {
        dismiss(animated: true, completion: nil)
        let vc = TabsVC()
        vc.hero.isEnabled = true
        vc.hero.modalAnimationType = .selectBy(presenting: .zoomSlide(direction: .down), dismissing: .zoomOut)
        vc.trainingVC.statusBarUpdate(withMessage: "Awesome run, \(Enhance.user.name)!")
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
