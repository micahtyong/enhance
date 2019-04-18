//
//  WelcomeToEnhanceVC.swift
//  Enhance
//
//  Created by Micah Yong on 4/13/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit
import Hero
import Firebase

class WelcomeToEnhanceVC: UIViewController {
    
    var firstTime: Bool = false
    var name : String = "X"
    let deviceID : String = UIDevice.current.identifierForVendor?.uuidString ?? "No device available"
    var timer = Timer()
    
    let ref : DatabaseReference! = Database.database().reference()
    
    let beginTraining = CustomLongButton()
    let thanksLabel = UILabel()
    let welcomeLabel = UILabel()
    let backButton = BackButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @objc func toMain(_ sender : CustomLongButton) {
        timer.invalidate()
        sender.pulse()
        let user = User(name: name, deviceID: deviceID)
        self.ref.child("Users").child(deviceID).setValue(["Name" : name])
        let trainVC = TrainingVC()
        trainVC.hero.isEnabled = true
        trainVC.hero.modalAnimationType = .selectBy(presenting: .zoom, dismissing: .zoomOut)
        self.present(trainVC, animated: true, completion: nil)
    }
    
    func setupUI() {
        view.backgroundColor = .white
        setupBeginTrainingButton()
        setupThanksLabel()
        setupWelcomeLabel()
        setupBackButton()
    }
    
    func isNewUser(_ x : Bool) {
        self.firstTime = x
    }
    
    func setupWelcomeLabel() {
        welcomeLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        welcomeLabel.backgroundColor = .white
        if firstTime {
            welcomeLabel.text = "You're now ready to start\nusing Enhance"
        } else {
            welcomeLabel.text = "Welcome back to\nEnhance"
        }
        welcomeLabel.numberOfLines = 0
        welcomeLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        welcomeLabel.textAlignment = .center
        welcomeLabel.textColor = .black
        
        view.addSubview(welcomeLabel)
        
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeLabel.topAnchor.constraint(equalTo: thanksLabel.bottomAnchor, constant: 10).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        welcomeLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setName(to name: String) {
        self.name = name
        thanksLabel.text = "Thanks, \(name)"
    }
    
    func setupThanksLabel() {
        thanksLabel.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        thanksLabel.backgroundColor = .white
        thanksLabel.textColor = UIColor(red: 0.98, green: 0.65, blue: 0.01, alpha: 1)
        thanksLabel.font = UIFont(name: "AvenirNext-Regular", size: 26)
        thanksLabel.textAlignment = .center
        thanksLabel.text = "Thanks, \(name)"
        
        self.view.addSubview(thanksLabel)
        
        thanksLabel.translatesAutoresizingMaskIntoConstraints = false
        thanksLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        thanksLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        thanksLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        thanksLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    func setupBeginTrainingButton() {
        beginTraining.setText(to: "Begin Training")
        beginTraining.addTarget(self, action: #selector(toMain), for: .touchUpInside)
        
        view.addSubview(beginTraining)
        
        beginTraining.translatesAutoresizingMaskIntoConstraints = false
        beginTraining.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        beginTraining.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
    }
    
    func setupBackButton() {
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        self.view.addSubview(backButton)
        
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        backButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func goBack(_ sender : UIButton) {
        sender.pulse()
        dismiss(animated: true, completion: nil)
    }

}
