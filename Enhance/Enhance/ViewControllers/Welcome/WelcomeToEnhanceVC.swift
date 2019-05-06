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
import FirebaseDatabase
import TransitionButton

class WelcomeToEnhanceVC: UIViewController {
    
    var user : User = User(name: "Micah", deviceID: "123")
    
    var firstTime: Bool = false
    var name : String = "X"
    let deviceID : String = UIDevice.current.identifierForVendor?.uuidString ?? "No device available"
    
    let ref : DatabaseReference! = Database.database().reference()
    
    let beginTraining = CustomLongButton()
    let beginTraining2 = TransitionButton(frame: CGRect(x: 100, y: 100, width: 150, height: 50))
    let thanksLabel = UILabel()
    let welcomeLabel = UILabel()
    let backButton = BackButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // UX
    
    func fetchUser(completion: @escaping (Bool) -> ()) {
        self.ref.child("Users").child(deviceID).observeSingleEvent(of: .value, with: { (snapshot) in
            var fetchedUser = User(name: "M", deviceID: "123")
            // Load
            if !snapshot.exists() { return }
            let userValues = snapshot.value as? NSDictionary
            let energyPoints = userValues?["Total"] as? Double ?? -1.0
            let str = userValues?["Strength"] as? Double ?? -1.0
            let sta = userValues?["Stamina"] as? Double ?? -1.0
            let cor = userValues?["Core"] as? Double ?? -1.0
            fetchedUser = User(name: self.name, deviceID: self.deviceID, energy: energyPoints, strength: str, stamina: sta, core: cor)
            
            if (fetchedUser.deviceID == "123") {
                completion(false)
            } else {
                self.user = fetchedUser
                completion(true)
            }
            
        }, withCancel: {error in
            print(error.localizedDescription)
        })
    }
    
    @objc func toMain(_ sender : TransitionButton) {
        sender.startAnimation()
        self.user = User(name: name, deviceID: deviceID)
        self.welcomeLabel.text = ""
        self.thanksLabel.text = ""
        
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            if self.firstTime {
                self.ref.child("Users").child(self.deviceID).setValue(["Name" : self.user.name, "Total" : self.user.energyPoints, "Strength" : self.user.strengthTotal, "Stamina" : self.user.staminaTotal, "Core" : self.user.staminaTotal])
                Enhance.user = self.user
                print("New user!")
            } else {
                self.fetchUser { success in
                    if success {
                        Enhance.user = self.user
                        print("Successfully fetched user!")
                    } else {
                        print("Error fetching user!")
                    }
                }
            }
            DispatchQueue.main.async(execute: { () -> Void in
                sender.stopAnimation(animationStyle: .expand, completion: {
                    let trainVC = TabsVC()
                    trainVC.trainingVC.statusBarUpdate(withMessage: "Get started with an activity!")
                    self.present(trainVC, animated: true, completion: nil)
                })
            })
        })
        
    }
    
    func isNewUser(_ x : Bool) {
        self.firstTime = x
    }
    
    func setName(to name: String) {
        self.name = name
        thanksLabel.text = "Thanks, \(name)"
    }
    
    
    
    // UI
    
    func setupUI() {
        self.view.backgroundColor = .white
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin]
//        setupBeginTrainingButton()
        setupBeginTraining2Button()
        setupThanksLabel()
        setupWelcomeLabel()
        setupBackButton()
    }
    
    func setupBeginTrainingButton() {
        beginTraining.setText(to: "Begin Training")
        beginTraining.addTarget(self, action: #selector(toMain), for: .touchUpInside)
        
        view.addSubview(beginTraining)
        
        beginTraining.translatesAutoresizingMaskIntoConstraints = false
        beginTraining.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        beginTraining.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
    }
    
    func setupBeginTraining2Button() {
        beginTraining2.backgroundColor = Enhance.customOrange
        beginTraining2.setTitle("Begin Training", for: .normal)
        beginTraining2.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        beginTraining2.titleLabel?.minimumScaleFactor = 0.5
        beginTraining2.titleLabel?.adjustsFontSizeToFitWidth = true
        beginTraining2.titleLabel?.textAlignment = .center
        beginTraining2.layer.borderWidth = 1
        beginTraining2.layer.borderColor = Enhance.customOrange.cgColor
        beginTraining2.cornerRadius = 20
        beginTraining2.spinnerColor = .white
        beginTraining2.addTarget(self, action: #selector(toMain), for: .touchUpInside)
        
        view.addSubview(beginTraining2)
        
        beginTraining2.translatesAutoresizingMaskIntoConstraints = false
        beginTraining2.heightAnchor.constraint(equalToConstant: 50).isActive = true
        beginTraining2.widthAnchor.constraint(equalToConstant: 280).isActive = true
        beginTraining2.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        beginTraining2.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
    }
    
    func setupWelcomeLabel() {
        welcomeLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 40)
        welcomeLabel.backgroundColor = .clear
        if firstTime {
            welcomeLabel.text = "You're now ready to start\nusing Enhance"
        } else {
            welcomeLabel.text = "Welcome back to\nEnhance"
        }
        welcomeLabel.minimumScaleFactor = 0.5
        welcomeLabel.adjustsFontSizeToFitWidth = true
        welcomeLabel.numberOfLines = 0
        welcomeLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        welcomeLabel.textAlignment = .center
        welcomeLabel.textColor = .black
        
        view.addSubview(welcomeLabel)
        
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeLabel.topAnchor.constraint(equalTo: thanksLabel.bottomAnchor, constant: 10).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        welcomeLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.44).isActive = true
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupThanksLabel() {
        thanksLabel.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        thanksLabel.backgroundColor = .clear
        thanksLabel.textColor = UIColor(red: 0.98, green: 0.65, blue: 0.01, alpha: 1)
        thanksLabel.font = UIFont(name: "AvenirNext-Regular", size: 26)
        thanksLabel.textAlignment = .center
        thanksLabel.text = "Thanks, \(name)"
        thanksLabel.minimumScaleFactor = 0.5
        thanksLabel.adjustsFontSizeToFitWidth = true
        
        self.view.addSubview(thanksLabel)
        
        thanksLabel.translatesAutoresizingMaskIntoConstraints = false
        thanksLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45).isActive = true
        thanksLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        thanksLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        thanksLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -50).isActive = true
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

//        let trainVC = TabsVC()
//        trainVC.hero.isEnabled = true
//        trainVC.hero.modalAnimationType = .selectBy(presenting: .zoom, dismissing: .zoomOut)
//        trainVC.trainingVC.statusBarUpdate(withMessage: "Get started with an activity!")
//        self.present(trainVC, animated: true, completion: nil)

//    @objc func toMain(_ sender : TransitionButton) {
//        sender.startAnimation()
//        self.user = User(name: name, deviceID: deviceID)
//
//        if firstTime {
//            self.ref.child("Users").child(deviceID).setValue(["Name" : user.name, "Total" : user.energyPoints, "Strength" : user.strengthTotal, "Stamina" : user.staminaTotal, "Core" : user.staminaTotal])
//            Enhance.user = self.user
//            print("New user!")
//        } else {
//            fetchUser { success in
//                if success {
//                    Enhance.user = self.user
//                    print("Successfully fetched user!")
//                } else {
//                    print("Error fetching user!")
//                }
//            }
//        }
//
//        DispatchQueue.main.async(execute: { () -> Void in
//            sender.stopAnimation(animationStyle: .expand, completion: {
//                let trainVC = TabsVC()
////                trainVC.hero.isEnabled = true
////                trainVC.hero.modalAnimationType = .selectBy(presenting: .zoom, dismissing: .zoomOut)
//                trainVC.trainingVC.statusBarUpdate(withMessage: "Get started with an activity!")
//                self.present(trainVC, animated: true, completion: nil)
//            })
//        })
//    }

