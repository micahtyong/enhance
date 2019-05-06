//
//  OnboardingView.swift
//  Enhance
//
//  Created by Micah Yong on 5/4/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit

class OnboardingView: UIView {
    
    let imageView : UIImageView = UIImageView()
    let headerText : UILabel = UILabel()
    let subText : UILabel = UILabel()
    
    var image : UIImage = UIImage(named: "onboarding1")!
    var header : String = "Improve your physique"
    var sub : String = "Train with 3 essential exercises that improve your everyday strength, stamina, and core."
    
    var screenHeight : CGFloat = 0
    var screenWidth : CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setToPage(_ pageNumber : Int) {
        if pageNumber == 1 {
            image = UIImage(named: "onboarding1")!
            header = "Improve your physique"
            sub = "Train with 3 essential exercises that improve your everyday strength, stamina, and core."
        } else if pageNumber == 2 {
            image = UIImage(named: "onboarding2")!
            sub = "Enhance is more than a fitness training plan. It uses frameworks like OpenPose and CoreMotion to verify your activity and correct your form."
            header = "Stay accountable"
        } else {
            image = UIImage(named: "onboarding3")!
            header = "Track your progress"
            sub = "Enhance customizes a training program, analyzes your performance, and tracks your improvement."
        }
        imageView.image = image
        headerText.text = header
        subText.text = sub
    }
    
    // UI
    
    func setupUI() {
        self.screenHeight = self.screenSize().size.height
        self.screenWidth = self.screenSize().size.width
        self.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        self.backgroundColor = .clear
        
        setupImage()
        setupHeader()
        setupSubHeader()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: screenHeight).isActive = true
        self.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
    }
    
    func setupHeader() {
        headerText.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight * 0.05)
        headerText.backgroundColor = .clear
        
        headerText.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        headerText.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
        headerText.minimumScaleFactor = 0.5
        headerText.adjustsFontSizeToFitWidth = true
        headerText.textAlignment = .center
        headerText.text = header
        
        self.addSubview(headerText)
        
        headerText.translatesAutoresizingMaskIntoConstraints = false
        headerText.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        headerText.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.05).isActive = true
        headerText.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        headerText.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0).isActive = true
    }
    
    func setupSubHeader() {
        subText.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.8, height: screenHeight * 0.09)
        subText.backgroundColor = .clear
        
        subText.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
        subText.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        subText.minimumScaleFactor = 0.5
        subText.adjustsFontSizeToFitWidth = true
        subText.numberOfLines = 0
        subText.lineBreakMode = .byWordWrapping
        subText.textAlignment = .center
        subText.text = sub
        
        self.addSubview(subText)
        
        subText.translatesAutoresizingMaskIntoConstraints = false
        subText.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        subText.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.09).isActive = true
        subText.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        subText.topAnchor.constraint(equalTo: headerText.bottomAnchor, constant: 0).isActive = true
    }
    
    func setupImage() {
        imageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth)
        imageView.contentMode = .center
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.image = image
        
        self.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
