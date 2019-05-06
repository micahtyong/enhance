//
//  SkipButton.swift
//  Enhance
//
//  Created by Micah Yong on 5/5/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit

class SkipButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton() {
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin]
        self.layer.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        self.layer.backgroundColor = UIColor.white.cgColor
        self.setTitle("skip", for: .normal)
        self.setTitleColor(UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1), for: .normal)
        self.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        self.titleLabel?.minimumScaleFactor = 0.5
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.textAlignment = .center
        
        let logoFactor : CGFloat = 0.14
        let screenWidth = self.screenSize().size.width
        let logoConstant = logoFactor * screenWidth
        
        self.heightAnchor.constraint(equalToConstant: logoConstant).isActive = true
        self.widthAnchor.constraint(equalToConstant: logoConstant * 2/3).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }

}
