//
//  InfoButton.swift
//  Enhance
//
//  Created by Micah Yong on 5/3/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit

class InfoButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton() {
        self.backgroundColor = .clear
        self.setImage(UIImage(named: "Info"), for: .normal)
        self.layer.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        let logoFactor : CGFloat = 0.055
        let screenHeight = self.screenSize().size.height
        let logoConstant = logoFactor * screenHeight
        
        self.heightAnchor.constraint(equalToConstant: logoConstant).isActive = true
        self.widthAnchor.constraint(equalToConstant: logoConstant).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }

}
