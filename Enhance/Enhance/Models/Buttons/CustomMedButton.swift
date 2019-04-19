//
//  CustomMedButton.swift
//  Enhance
//
//  Created by Micah Yong on 4/13/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit

class CustomMedButton: UIButton {
    
    let customOrange = UIColor(red: 0.98, green: 0.65, blue: 0.01, alpha: 1)
    let customWhite = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    
    var isInverted = false
    var text: String = "Enter text"
    
    init(withText holder: String, withInverted: Bool) {
        super.init(frame: UIScreen.main.bounds)
        self.text = holder
        self.isInverted = withInverted
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButton() {
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin]
        self.frame = CGRect(x: 0, y: 0, width: 160, height: 50)
        if isInverted {
            self.layer.backgroundColor = customWhite.cgColor
            self.setTitleColor(customOrange, for: .normal)
        } else {
            self.layer.backgroundColor = customOrange.cgColor
            self.setTitleColor(customWhite, for: .normal)
        }
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        self.titleLabel?.minimumScaleFactor = 0.5
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.textAlignment = .center
        self.layer.borderWidth = 1
        self.layer.borderColor = customOrange.cgColor
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
//        let logoFactor : CGFloat = 0.389
//        let screenHeight = self.screenSize().size.width
//        let labelConstant = logoFactor * screenHeight
        
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.widthAnchor.constraint(equalToConstant: 160).isActive = true
    }

}
