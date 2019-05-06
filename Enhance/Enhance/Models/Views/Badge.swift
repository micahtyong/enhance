//
//  Badge.swift
//  Enhance
//
//  Created by Micah Yong on 4/23/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit

class Badge: UIView {

    let badgeButton : UIButton = UIButton()
    var badgeIcon : UIImage = UIImage(named: "tempLogo")!
    
    let header : UILabel = UILabel()
    var level : Int = 1
    
    let text : UILabel = UILabel()
    var levelDescription : String = "40 pushups total"
    
    var screenHeight : CGFloat = 0
    var screenWidth : CGFloat = 0
    
    init(frame: CGRect, badge: UIImage) {
        super.init(frame: frame)
        badgeIcon = badge
        setupUI()
    }
    
    // UX
    
    func setDescription(to text: String) {
        levelDescription = text
        self.text.text = levelDescription
    }
    
    func setLevel(to level: Int) {
        self.level = level
        self.header.text = "Level \(level)"
    }
    
    @objc func pulse(_ sender : CoreButton) {
        sender.pulse()
    }
    
    // UI
    
    func setupUI() {
        screenHeight = self.screenSize().size.height
        screenWidth = self.screenSize().size.width
        
        self.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.78, height: screenHeight * 0.062)
        self.backgroundColor = .white
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: screenWidth * 0.78).isActive = true
        self.heightAnchor.constraint(equalToConstant: screenHeight * 0.062).isActive = true
        
        setupBadge()
        setupHeader()
        setupText()
    }
    
    func setupText() {
        text.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.17, height: screenHeight * 0.03)
        text.backgroundColor = .clear
        text.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
        text.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
        text.minimumScaleFactor = 0.5
        text.adjustsFontSizeToFitWidth = true
        text.text = levelDescription
        
        self.addSubview(text)
        
        text.translatesAutoresizingMaskIntoConstraints = false
        text.widthAnchor.constraint(equalToConstant: screenWidth * 0.4).isActive = true
        text.heightAnchor.constraint(equalToConstant: screenHeight * 0.04).isActive = true
        text.leadingAnchor.constraint(equalTo: badgeButton.trailingAnchor, constant: 15).isActive = true
        text.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 0).isActive = true
    }
    
    func setupHeader() {
        header.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.17, height: screenHeight * 0.023)
        header.backgroundColor = .white
        
        header.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        header.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        header.minimumScaleFactor = 0.5
        header.adjustsFontSizeToFitWidth = true
        header.text = "Level \(level)"
        
        self.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.widthAnchor.constraint(equalToConstant: screenWidth * 0.16).isActive = true
        header.heightAnchor.constraint(equalToConstant: screenHeight * 0.023).isActive = true
        header.leadingAnchor.constraint(equalTo: badgeButton.trailingAnchor, constant: 15).isActive = true
        header.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true
    }
    
    func setupBadge() {
        badgeButton.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.12, height: screenHeight * 0.062)
        badgeButton.backgroundColor = .white
        badgeButton.setImage(badgeIcon, for: .normal)
        badgeButton.addTarget(self, action: #selector(pulse), for: .touchUpInside)
        
        self.addSubview(badgeButton)
        
        badgeButton.translatesAutoresizingMaskIntoConstraints = false
        badgeButton.widthAnchor.constraint(equalToConstant: screenWidth * 0.12).isActive = true
        badgeButton.heightAnchor.constraint(equalToConstant: screenWidth * 0.12).isActive = true
        badgeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        badgeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
