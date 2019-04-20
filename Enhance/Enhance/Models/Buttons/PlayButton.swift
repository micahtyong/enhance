//
//  PlayButton.swift
//  Enhance
//
//  Created by Micah Yong on 4/19/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit
import Hero

class PlayButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    @objc func play(_ sender : CoreButton) {
        sender.pulse()
    }
    
    func indicateGood() {
        self.pulse()
        self.setImage(UIImage(named: "goodButton"), for: .normal)
    }
    
    func indicateBad() {
        self.pulse()
        self.setImage(UIImage(named: "badButton"), for: .normal)
    }
    
    func screen() -> CGRect {
        let screenSize: CGRect = UIScreen.main.bounds
        return screenSize
    }
    
    func setupButton() {
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin]
        self.backgroundColor = .clear
        self.setImage(UIImage(named: "playPurple"), for: .normal)
        self.layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.addTarget(self, action: #selector(play), for: .touchUpInside)
        
        let logoFactor : CGFloat = 0.148
        let screenHeight = self.screen().size.height
        let logoConstant = logoFactor * screenHeight
        
        self.heightAnchor.constraint(equalToConstant: logoConstant).isActive = true
        self.widthAnchor.constraint(equalToConstant: logoConstant).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }

}
