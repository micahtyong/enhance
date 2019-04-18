//
//  CoreButton.swift
//  Enhance
//
//  Created by Micah Yong on 4/16/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import Foundation
import UIKit

class CoreButton : UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func igniteButton() {
        self.setImage(UIImage(named: "CoreOrangeBall"), for: .normal)
    }
    
    func extinguishButton() {
        self.setImage(UIImage(named: "CoreGreyBall"), for: .normal)
    }
    
    func setupButton() {
        self.backgroundColor = .clear
        self.setImage(UIImage(named: "CoreGreyBall"), for: .normal)
        self.layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        self.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
}
