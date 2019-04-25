//
//  DiagnoseVC.swift
//  Enhance
//
//  Created by Micah Yong on 4/11/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit
import Hero
import Firebase
import FirebaseDatabase
import PopupDialog

class DiagnoseVC: UIViewController {
    
    let tellUsLabel = UILabel()
    let getStarted = CustomLongButton()
    let alreadyMember = CustomLongButton()
    let backButton = BackButton()
    
    var name : String?
    
    let customOrange = UIColor(red: 0.98, green: 0.65, blue: 0.01, alpha: 1)
    let customWhite = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    
    let ref : DatabaseReference! = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // UX
    func checkIfUserExists(completion: @escaping (Bool) -> ()) -> Bool {
        var exists = false
        self.ref.child("Users").child(Enhance.deviceID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Load
            if snapshot.exists() {
                exists = true
                let userValues = snapshot.value as? NSDictionary
                self.name = userValues?["Name"] as? String ?? "X"
            }
            if exists {
                completion(true)
            } else {
                completion(false)
            }
        }, withCancel: {error in
            print(error.localizedDescription)
        })
        return exists
    }
    
    @objc func getStartedButtonTapped(_ sender:UIButton) {
        sender.pulse()
        let enterNameVC = EnterNameVC()
        enterNameVC.hero.isEnabled = true
        enterNameVC.isNewUser(true)
        enterNameVC.hero.modalAnimationType = .selectBy(presenting: .zoom, dismissing: .zoomOut)
        self.present(enterNameVC, animated: true, completion: nil)
    }
    
    @objc func signInButtonTapped(_ sender:UIButton) {
        sender.pulse()
        checkIfUserExists { success in
            if success {
                // get name
                let thanksVC = WelcomeToEnhanceVC()
                thanksVC.hero.isEnabled = true
                thanksVC.hero.modalAnimationType = .selectBy(presenting: .fade, dismissing: .zoomOut)
                if self.name != nil {
                    thanksVC.setName(to: self.name!)
                    thanksVC.isNewUser(false)
                    self.present(thanksVC, animated: true, completion: nil)
                }
            } else {
                print("Error fetching user!")
                self.noUserAlert()
            }
        }
    }
    // UI
    
    func noUserAlert() {
        // Prepare the popup assets
        let title = "UH OH!"
        let message = "We were unable to find you in our database. Create an account now by clicking 'Get started'!"
        // Create the dialog
        let popup = PopupDialog(title: title, message: message)
        // Create buttons
        let cancelButton = CancelButton(title: "OK") {
            print("You canceled the dialog.")
        }
        popup.addButtons([cancelButton])
        self.present(popup, animated: true, completion: nil)
    }
    
    func setupUI() {
        self.view.backgroundColor = .white
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin]
        setupTellUs()
        setupGetStarted()
        setupAlreadyAMember()
        setupBackButton()
    }
    
    func setupTellUs() {
        tellUsLabel.backgroundColor = .white
        tellUsLabel.text = "Tell us how you'd like to\nimprove your body"
        tellUsLabel.numberOfLines = 0
        tellUsLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        tellUsLabel.minimumScaleFactor = 0.5
        tellUsLabel.adjustsFontSizeToFitWidth = true
        tellUsLabel.textAlignment = .center
        tellUsLabel.textColor = .black
        
        view.addSubview(tellUsLabel)
        
        tellUsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tellUsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30).isActive = true
        tellUsLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tellUsLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        tellUsLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupGetStarted() {
        getStarted.addTarget(self, action: #selector(getStartedButtonTapped), for: .touchUpInside)
        getStarted.setText(to: "Get started")
        
        view.addSubview(getStarted)
        
        getStarted.topAnchor.constraint(equalTo: tellUsLabel.bottomAnchor, constant: 20).isActive = true
        getStarted.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        getStarted.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupAlreadyAMember() {
        alreadyMember.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        alreadyMember.setText(to: "Already a member? Sign in")
        alreadyMember.setInverted()
        
        view.addSubview(alreadyMember)
        
        alreadyMember.topAnchor.constraint(equalTo: getStarted.bottomAnchor, constant: 20).isActive = true
        alreadyMember.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        alreadyMember.translatesAutoresizingMaskIntoConstraints = false
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
