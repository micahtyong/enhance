//
//  BackButton.swift
//  Enhance
//
//  Created by Micah Yong on 4/11/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit

class BackButton: UIButton {

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
        self.setImage(UIImage(named: "backButtonDark"), for: .normal)
        self.layer.frame = CGRect(x: 0, y: 0, width: 35, height: 20)
        
        self.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.widthAnchor.constraint(equalToConstant: 35).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
