//
//  CustomLongButton.swift
//  Enhance
//
//  Created by Micah Yong on 4/13/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit

class CustomLongButton: UIButton {
    
    let customOrange = UIColor(red: 0.98, green: 0.65, blue: 0.01, alpha: 1)
    let customWhite = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    
    var text: String = "Text here"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setText(to holder: String) {
        self.text = holder
        self.setTitle(text, for: .normal)
    }
    
    func setInverted() {
        self.setTitleColor(customOrange, for: .normal)
        self.layer.backgroundColor = UIColor.white.cgColor
    }
    
    func setNormal() {
        self.setTitleColor(customWhite, for: .normal)
        self.layer.backgroundColor = customOrange.cgColor
    }
    
    func setupButton() {
        self.layer.backgroundColor = customOrange.cgColor
        self.setTitle(text, for: .normal)
        self.setTitleColor(customWhite, for: .normal)
        self.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        self.titleLabel?.textAlignment = .center
        self.layer.borderWidth = 1
        self.layer.borderColor = customOrange.cgColor
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.widthAnchor.constraint(equalToConstant: 280).isActive = true
    }

}
