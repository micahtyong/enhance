//
//  PedometerView.swift
//  Enhance
//
//  Created by Micah Yong on 4/21/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit

class PedometerView: UIView {

    var stopWatch : Stopwatch = Stopwatch()
    var stopWatchLabel : UILabel = UILabel()
    
    var distanceLabel : UILabel = UILabel()
    var stepsLabel : UILabel = UILabel()
    
    var screenHeight : CGFloat = 0
    var screenWidth : CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setMainText(to text: String) {
        stopWatchLabel.text = text
    }
    
    func setSteps(to steps: Double) {
        stepsLabel.text = "\(steps) steps"
    }
    
    func setDistance(to distance: Double, in units: String) {
        distanceLabel.text = "\(distance) \(units)"
    }
    
    func calibrateTime() {
        stopWatch.updateTime()
        stopWatchLabel.text = "\(stopWatch.strMinutes):\(stopWatch.strSeconds)"
    }
    
    func resetTime() {
        stopWatch.resetTimer()
        stopWatchLabel.text = "\(stopWatch.strMinutes):\(stopWatch.strSeconds)"
    }
    
    func setupUI() {
        self.screenHeight = self.screenSize().size.height
        self.screenWidth = self.screenSize().size.width
        self.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.55, height: screenHeight * 0.24)
        self.backgroundColor = .clear
        
        setupStopwatch()
        setupDistance()
        setupSteps()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: screenHeight * 0.24).isActive = true
        self.widthAnchor.constraint(equalToConstant: screenWidth * 0.55).isActive = true
    }
    
    func setupSteps() {
        stepsLabel.frame = CGRect(x: 0, y: 0, width: 170, height: 47)
        stepsLabel.backgroundColor = .white
        stepsLabel.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
        stepsLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 30)
        stepsLabel.minimumScaleFactor = 0.5
        stepsLabel.adjustsFontSizeToFitWidth = true
        stepsLabel.textAlignment = .center
        stepsLabel.text = "0 steps"
        
        self.addSubview(stepsLabel)
        
        stepsLabel.translatesAutoresizingMaskIntoConstraints = false
        stepsLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        stepsLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.24).isActive = true
        stepsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        stepsLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 0).isActive = true
    }
    
    func setupDistance() {
        distanceLabel.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.55, height: 45)
        distanceLabel.backgroundColor = .clear
        distanceLabel.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
        distanceLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 30)
        distanceLabel.minimumScaleFactor = 0.5
        distanceLabel.adjustsFontSizeToFitWidth = true
        distanceLabel.textAlignment = .center
        distanceLabel.text = "0.00 miles"
        
        self.addSubview(distanceLabel)
        
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        distanceLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.24).isActive = true
        distanceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        distanceLabel.topAnchor.constraint(equalTo: stopWatchLabel.bottomAnchor, constant: 0).isActive = true
    }
    
    func setupStopwatch() {
        stopWatchLabel.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.55, height: 100)
        stopWatchLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        stopWatchLabel.font = UIFont(name: "AvenirNext-Regular", size: 80)
        stopWatchLabel.minimumScaleFactor = 0.5
        stopWatchLabel.adjustsFontSizeToFitWidth = true
        stopWatchLabel.textAlignment = .center
        stopWatchLabel.text = "00:00"
        
        self.addSubview(stopWatchLabel)
        
        stopWatchLabel.translatesAutoresizingMaskIntoConstraints = false
        stopWatchLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        stopWatchLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.52).isActive = true
        stopWatchLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        stopWatchLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
