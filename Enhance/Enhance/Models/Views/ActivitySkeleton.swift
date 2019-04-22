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
    let customGreen = UIColor(red: 0.12, green: 0.83, blue: 0.1, alpha: 1).cgColor
    let customRed = UIColor(red: 0.83, green: 0.1, blue: 0.1, alpha: 1).cgColor
    let customGold = UIColor(red: 0.72, green: 0.65, blue: 0.48, alpha: 1).cgColor
    let customOrange = UIColor(red: 0.98, green: 0.65, blue: 0.01, alpha: 1).cgColor
    
    var screenHeight : CGFloat = 0
    var screenWidth : CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setDone() {
        borderFrame.layer.borderColor = customOrange
        displayLabel.text = ""
        playButton.finish()
    }
    
    func setGood() {
        borderFrame.layer.borderColor = customGreen
        playButton.indicateGood()
    }
    
    func setBad() {
        borderFrame.layer.borderColor = customRed
        playButton.indicateBad()
    }
    
    func setOriginal() {
        borderFrame.layer.borderColor = customOrange
        playButton.indicateBad()
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
    
    func setCounterText(to text: String) {
        displayLabel.text = text
    }
    
    func bounceCounter() {
        displayLabel.bounce()
    }
    
    func setupCounterLabel() {
        displayLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        displayLabel.backgroundColor = .clear
        displayLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        displayLabel.font = UIFont(name: "AvenirNext-Regular", size: 100)
        displayLabel.minimumScaleFactor = 0.5
        displayLabel.adjustsFontSizeToFitWidth = true
        displayLabel.textAlignment = .center
        displayLabel.text = ""
        
        self.addSubview(displayLabel)
        
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        displayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        displayLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: screenHeight * 0.20 * 1).isActive = true
        displayLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25).isActive = true
        displayLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4).isActive = true
        displayLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
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
        borderFrame.layer.borderColor = customOrange
        
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

extension UILabel {
    @objc func bounce() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.8
        pulse.fromValue = 0.9
        pulse.toValue = 1.0
        pulse.initialVelocity = 0.9
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
    }
}
