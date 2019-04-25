//
//  ProfileVC.swift
//  Enhance
//
//  Created by Micah Yong on 4/18/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {
    
    var user : User = Enhance.user
    
    let ref : DatabaseReference! = Database.database().reference()
    var databaseHandler : DatabaseHandle?
    
    // HEADER
    let headerBackground : UIView = UIView()
    let nameLabel : UILabel = UILabel()
    
    // ENERGY SECTION
    let energySection : UIView = UIView()
    let energyHeader : UILabel = UILabel()
    let energyLabel : UILabel = UILabel()
    
    // BADGES SECTION
    let badgesSection : UIView = UIView()
    let badgesHeader : UILabel = UILabel()
    var badges : BadgesView = BadgesView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), user: Enhance.user)
    
    var screenHeight : CGFloat = 0
    var screenWidth : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = Enhance.user
        badges = BadgesView(frame: self.view.frame, user: Enhance.user)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateFields()
    }
    
    // UX
    
    func updateFields() {
        nameLabel.text = self.user.name
        energyLabel.text = "\(self.user.energyPoints)"
        badges = BadgesView(frame: self.view.frame, user: Enhance.user)
    }
    
    // UI
    
    func setupUI() {
        screenHeight = self.screenSize().size.height
        screenWidth = self.screenSize().size.width
        self.view.backgroundColor = .white
        setupHeader()
        setupName()
        setupEnergySection()
        setupBadgeSection()
        setupBadges()
    }
    
    func setupBadges() {
        self.view.addSubview(badges)
        
        badges.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        badges.topAnchor.constraint(equalTo: badgesSection.bottomAnchor, constant: 10).isActive = true
        badges.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.79).isActive = true
        badges.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.29).isActive = true
    }
    
    func setupEnergySection() {
        energySection.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.78, height: screenHeight * 0.117)
        energySection.backgroundColor = .white
        energySection.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        
        view.addSubview(energySection)
        
        energySection.translatesAutoresizingMaskIntoConstraints = false
        energySection.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.78).isActive = true
        energySection.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.117).isActive = true
        energySection.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        energySection.topAnchor.constraint(equalTo: headerBackground.bottomAnchor, constant: 10).isActive = true
        
        setupEnergyHeader()
        setupEnergyLine()
        setupEnergyLabel()
    }
    
    func setupBadgeSection() {
        badgesSection.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.78, height: screenHeight * 0.045)
        badgesSection.backgroundColor = .white
        badgesSection.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        
        view.addSubview(badgesSection)
        
        badgesSection.translatesAutoresizingMaskIntoConstraints = false
        badgesSection.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.78).isActive = true
        badgesSection.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.045).isActive = true
        badgesSection.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        badgesSection.topAnchor.constraint(equalTo: energySection.bottomAnchor, constant: 10).isActive = true
        
        setupBadgesHeader()
        setupBadgesLine()
    }
    
    func setupBadgesLine() {
        let line : UIView = lineBreak()
        
        line.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        line.topAnchor.constraint(equalTo: badgesHeader.bottomAnchor, constant: 5).isActive = true
    }
    
    func setupBadgesHeader() {
        badgesHeader.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.29, height: screenHeight * 0.03)
        badgesHeader.backgroundColor = .white
        
        badgesHeader.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        badgesHeader.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        badgesHeader.minimumScaleFactor = 0.5
        badgesHeader.adjustsFontSizeToFitWidth = true
        badgesHeader.text = "Badges"
        
        view.addSubview(badgesHeader)
        
        badgesHeader.translatesAutoresizingMaskIntoConstraints = false
        badgesHeader.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.29).isActive = true
        badgesHeader.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.03).isActive = true
        badgesHeader.leadingAnchor.constraint(equalTo: badgesSection.leadingAnchor, constant: 0).isActive = true
        badgesHeader.topAnchor.constraint(equalTo: badgesSection.topAnchor, constant: 0).isActive = true
    }
    
    func setupEnergyLabel() {
        energyLabel.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.31, height: screenHeight * 0.055)
        energyLabel.backgroundColor = .white
        energyLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        energyLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 32)
        energyLabel.minimumScaleFactor = 0.5
        energyLabel.adjustsFontSizeToFitWidth = true
        energyLabel.textAlignment = .center
        energyLabel.text = "\(user.energyPoints)"
        
        view.addSubview(energyLabel)
        
        energyLabel.translatesAutoresizingMaskIntoConstraints = false
        energyLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.31).isActive = true
        energyLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.055).isActive = true
        energyLabel.centerXAnchor.constraint(equalTo: energySection.centerXAnchor, constant: 0).isActive = true
        energyLabel.topAnchor.constraint(equalTo: energyHeader.bottomAnchor, constant: 15).isActive = true

    }
    
    func setupEnergyLine() {
        let line : UIView = lineBreak()
        
        line.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        line.topAnchor.constraint(equalTo: energyHeader.bottomAnchor, constant: 5).isActive = true
    }
    
    func lineBreak() -> UIView {
        let lineBreak : UIView = UIView()
        lineBreak.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.782, height: 1)
        lineBreak.backgroundColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
        
        view.addSubview(lineBreak)
        
        lineBreak.translatesAutoresizingMaskIntoConstraints = false
        lineBreak.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.782).isActive = true
        lineBreak.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return lineBreak
    }
    
    func setupEnergyHeader() {
        energyHeader.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.29, height: screenHeight * 0.03)
        energyHeader.backgroundColor = .white
        
        energyHeader.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        energyHeader.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        energyHeader.minimumScaleFactor = 0.5
        energyHeader.adjustsFontSizeToFitWidth = true
        energyHeader.text = "Energy points"
    
        view.addSubview(energyHeader)
        
        energyHeader.translatesAutoresizingMaskIntoConstraints = false
        energyHeader.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.29).isActive = true
        energyHeader.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.03).isActive = true
        energyHeader.leadingAnchor.constraint(equalTo: energySection.leadingAnchor, constant: 0).isActive = true
        energyHeader.topAnchor.constraint(equalTo: energySection.topAnchor, constant: 0).isActive = true
    }
    
    func setupName() {
        nameLabel.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.36, height: screenHeight * 0.05)
        nameLabel.backgroundColor = .clear
        nameLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        nameLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 32)
        nameLabel.minimumScaleFactor = 0.5
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textAlignment = .center
        nameLabel.text = user.name
        
        view.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.36).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: headerBackground.bottomAnchor, constant: -20).isActive = true
    }
    
    func setupHeader() {
        headerBackground.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight * 0.33)
        headerBackground.backgroundColor = .white
        
        // Add image background
        let image0 = UIImage(named: "profileBG1.png")?.cgImage
        let layer0 = CALayer()
        layer0.contents = image0
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1.17, b: 0, c: 0, d: 1, tx: -0.08, ty: 0))
        layer0.bounds = headerBackground.bounds
        layer0.position = headerBackground.center
        headerBackground.layer.addSublayer(layer0)
        
        view.addSubview(headerBackground)
        
        headerBackground.translatesAutoresizingMaskIntoConstraints = false
        headerBackground.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        headerBackground.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33).isActive = true
        headerBackground.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        headerBackground.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
    }
}
