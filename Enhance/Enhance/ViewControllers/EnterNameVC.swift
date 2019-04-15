//
//  EnterNameVC.swift
//  Enhance
//
//  Created by Micah Yong on 4/11/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit
import Hero

class EnterNameVC: UIViewController {
    
    var newUserStatus : Bool = true
    
    var enhanceLogo = UIImageView()
    let backButton = BackButton()
    let enterName = CustomTextField()
    let goButton = CustomMedButton(withText: "Go!", withInverted: false)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = .white
        setupLogo()
        setupBackButton()
        setupNameTextField()
        setupGoButton()
    }
    
    func isNewUser(_ isNew : Bool) {
        self.newUserStatus = isNew
    }
    
    func setupGoButton() {
        goButton.addTarget(self, action: #selector(welcomeToEnhance), for: .touchUpInside)
        
        self.view.addSubview(goButton)
        
        goButton.translatesAutoresizingMaskIntoConstraints = false
        goButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        goButton.topAnchor.constraint(equalTo: enterName.bottomAnchor, constant: 20).isActive = true
    }
    
    @objc func welcomeToEnhance(_ sender : CustomMedButton) {
        sender.pulse()
        let thanksVC = WelcomeToEnhanceVC()
        thanksVC.hero.isEnabled = true
        thanksVC.hero.modalAnimationType = .selectBy(presenting: .zoom, dismissing: .zoomOut)
        if let name = enterName.textField.text, !name.isEmpty {
            thanksVC.setName(to: name)
            thanksVC.isNewUser(newUserStatus)
            self.present(thanksVC, animated: true, completion: nil)
        }
    }
    
    func setupNameTextField() {
        enterName.setPlaceHolder(holder: "Enter Name")
        self.view.addSubview(enterName)
        
        enterName.translatesAutoresizingMaskIntoConstraints = false
        enterName.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        enterName.topAnchor.constraint(equalTo: enhanceLogo.bottomAnchor, constant: 50).isActive = true
    }
    
    func setupLogo() {
        let logo = UIImage(named: "tempLogo")
        enhanceLogo = UIImageView(image: logo)
        enhanceLogo.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        
        self.view.addSubview(enhanceLogo)
        
        enhanceLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        enhanceLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        enhanceLogo.widthAnchor.constraint(equalToConstant: 120).isActive = true
        enhanceLogo.heightAnchor.constraint(equalToConstant: 120).isActive = true
        enhanceLogo.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupBackButton() {
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        self.view.addSubview(backButton)
        
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        backButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func goBack(_ sender:UIButton) {
        sender.pulse()
        dismiss(animated: true, completion: nil)
    }
    

}
