//
//  EnterNameVC.swift
//  Enhance
//
//  Created by Micah Yong on 4/11/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit

class EnterNameVC: UIViewController {
    
    var enhanceLogo = UIImageView()
    let backButton = BackButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = .white
        setupLogo()
        setupBackButton()
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
