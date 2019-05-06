//
//  CoreButton.swift
//  Enhance
//
//  Created by Micah Yong on 4/16/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import Foundation
import UIKit
import Hero
import TransitionButton

class CoreButton : TransitionButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    @objc func launchCoreMLVC(_ sender : CoreButton) {
//        sender.pulse()
    }
    
    func igniteButton() {
        self.setImage(UIImage(named: "CoreOrangeBall"), for: .normal)
        self.pulse()
    }
    
    func extinguishButton() {
        self.setImage(UIImage(named: "CoreGreyBall"), for: .normal)
    }
    
    func screen() -> CGRect {
        let screenSize: CGRect = UIScreen.main.bounds
        return screenSize
    }
    
    func setupButton() {
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin]
        self.backgroundColor = .clear
        self.setImage(UIImage(named: "CoreGreyBall"), for: .normal)
        self.layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.addTarget(self, action: #selector(launchCoreMLVC), for: .touchUpInside)
        
        let logoFactor : CGFloat = 0.13
        let screenHeight = self.screen().size.height
        let logoConstant = logoFactor * screenHeight
        
        self.heightAnchor.constraint(equalToConstant: logoConstant).isActive = true
        self.widthAnchor.constraint(equalToConstant: logoConstant).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
