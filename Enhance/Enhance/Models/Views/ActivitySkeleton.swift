//
//  ActivitySkeleton.swift
//  Enhance
//
//  Created by Micah Yong on 4/19/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit

class ActivitySkeleton: UIView {
    
    var borderFrame : UIView = UIView()
    var playButton : PlayButton = PlayButton()
    var displayLabel : UILabel = UILabel()
    
    let customPurple = UIColor(red: 0.29, green: 0.18, blue: 0.51, alpha: 1).cgColor
    
    var screenHeight : CGFloat = 0
    var screenWidth : CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        self.screenHeight = self.screenSize().size.height
        self.screenWidth = self.screenSize().size.width
        self.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        self.backgroundColor = .clear
        
        setupBorder()
        setupButton()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: screenHeight).isActive = true
        self.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
    }
    
    func setupButton() {
        self.addSubview(playButton)
        
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        playButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: screenHeight * 0.111 * -1).isActive = true
    }
    
    func setupBorder() {
        borderFrame.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        borderFrame.backgroundColor = .clear
        borderFrame.layer.borderWidth = 5
        borderFrame.layer.borderColor = customPurple
        
        self.addSubview(borderFrame)
        
        borderFrame.translatesAutoresizingMaskIntoConstraints = false
        borderFrame.heightAnchor.constraint(equalToConstant: screenHeight).isActive = true
        borderFrame.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        borderFrame.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        borderFrame.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true // not sure yet
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
