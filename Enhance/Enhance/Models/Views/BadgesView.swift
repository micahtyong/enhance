//
//  BadgesView.swift
//  Enhance
//
//  Created by Micah Yong on 4/23/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit

class BadgesView: UIView {
    
    var user : User = User(name: "Micah", deviceID: "123")
    
    var strengthBadge : Badge = Badge(frame: CGRect(x: 0, y: 0, width: 100, height: 100), badge: UIImage(named: "StrengthBadge")!)
    var staminaBadge : Badge = Badge(frame: CGRect(x: 0, y: 0, width: 100, height: 100), badge: UIImage(named: "EnergyBadge")!)
    var coreBadge : Badge = Badge(frame: CGRect(x: 0, y: 0, width: 100, height: 100), badge: UIImage(named: "CoreBadge")!)
    
    var screenHeight : CGFloat = 0
    var screenWidth : CGFloat = 0

    init(frame: CGRect, user: User) {
        super.init(frame: frame)
        self.user = user
        setupUI()
    }
    
    // UI
    
    func setupUI() {
        screenHeight = self.screenSize().size.height
        screenWidth = self.screenSize().size.width
        
        self.backgroundColor = .clear
        self.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.79, height: screenHeight * 0.29)
        self.layer.backgroundColor = UIColor.white.cgColor
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setupBadges()
    }
    
    func setupBadges() {
        strengthBadge.setLevel(to: Int(round(user.strengthLevel())))
        strengthBadge.setDescription(to: "\(round(user.strengthTotal)) pushups total")
        self.addSubview(strengthBadge)
        strengthBadge.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        strengthBadge.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        staminaBadge.setLevel(to: Int(round(user.staminaLevel())))
        staminaBadge.setDescription(to: "\(round(user.staminaTotal)) miles total")
        self.addSubview(staminaBadge)
        staminaBadge.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        staminaBadge.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        coreBadge.setLevel(to: Int(round(user.coreLevel())))
        coreBadge.setDescription(to: "\(round(user.coreTotal)) seconds of planks")
        self.addSubview(coreBadge)
        coreBadge.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        coreBadge.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
