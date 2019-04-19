//
//  LandingPageVC.swift
//  Enhance
//
//  Created by Micah Yong on 4/10/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit
import Hero

class LandingPageVC: UIViewController {
    
    var enhanceLogo = UIImageView()
    let enhanceLabel = UILabel()
    let descriptionLabel = UILabel()
    
    let beginButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = .white
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin]
        setupEnhanceLabel()
        setupDescriptionLabel()
        setupEnhanceLogo()
        setupBeginButton()
    }
    
    func setupBeginButton() {
        beginButton.backgroundColor = .white
        beginButton.setTitle("TAP TO BEGIN", for: .normal)
        beginButton.setTitleColor(UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1), for: .normal)
        beginButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        beginButton.titleLabel!.minimumScaleFactor = 0.5
        beginButton.titleLabel!.adjustsFontSizeToFitWidth = true
        beginButton.addTarget(self, action: #selector(beginButtonTapped), for: .touchUpInside)
        
        beginButton.clipsToBounds = true
        
        self.view.addSubview(beginButton)
        
        let logoFactor : CGFloat = 0.07
        let screenHeight = self.screenSize().size.height
        let labelConstant = logoFactor * screenHeight
        
        beginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        beginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        beginButton.heightAnchor.constraint(equalToConstant: labelConstant).isActive = true
        beginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        beginButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func beginButtonTapped(_ sender:UIButton) {
        sender.pulse()
        let diagnoseVC = DiagnoseVC()
        diagnoseVC.hero.isEnabled = true
        diagnoseVC.hero.modalAnimationType = .selectBy(presenting: .fade, dismissing: .fade)
        self.present(diagnoseVC, animated: true, completion: nil)
    }
    
    func setupEnhanceLogo() {
        let logo = UIImage(named: "tempLogo")
        enhanceLogo = UIImageView(image: logo)
        enhanceLogo.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        self.view.addSubview(enhanceLogo)
        
        let logoFactor : CGFloat = 0.14
        let screenHeight = self.screenSize().size.height
        let logoConstant = logoFactor * screenHeight
        
        enhanceLogo.bottomAnchor.constraint(equalTo: enhanceLabel.topAnchor, constant: -10).isActive = true
        enhanceLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        enhanceLogo.widthAnchor.constraint(equalToConstant: logoConstant).isActive = true
        enhanceLogo.heightAnchor.constraint(equalToConstant: logoConstant).isActive = true
        enhanceLogo.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupEnhanceLabel() {
        enhanceLabel.backgroundColor = .white
        enhanceLabel.text = "E N H A N C E"
        enhanceLabel.font = UIFont(name: "AvenirNext-Regular", size: 30)
        enhanceLabel.minimumScaleFactor = 0.5
        enhanceLabel.adjustsFontSizeToFitWidth = true
        enhanceLabel.textAlignment = .center
        enhanceLabel.textColor = .black
        
        view.addSubview(enhanceLabel)
        
        let logoFactor : CGFloat = 0.07
        let screenHeight = self.screenSize().size.height
        let labelConstant = logoFactor * screenHeight
        
        enhanceLabel.heightAnchor.constraint(equalToConstant: labelConstant).isActive = true
        enhanceLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        enhanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        enhanceLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        enhanceLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupDescriptionLabel() {
        descriptionLabel.backgroundColor = .white
        descriptionLabel.text = "PERSONALIZED BODY TRAINING"
        descriptionLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        descriptionLabel.minimumScaleFactor = 0.5
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
        
        self.view.addSubview(descriptionLabel)
        
        descriptionLabel.topAnchor.constraint(equalTo: enhanceLabel.bottomAnchor, constant: 0).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    }

}

extension UIViewController {
    // use .width and .height to access screen width and height size
    func screenSize() -> CGRect {
        let screenSize: CGRect = UIScreen.main.bounds
        return screenSize
    }
}

extension UIButton {
    @objc func pulse() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.8
        pulse.fromValue = 0.9
        pulse.toValue = 1.0
        pulse.initialVelocity = 0.9
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
    }
    
    func screenSize() -> CGRect {
        let screenSize: CGRect = UIScreen.main.bounds
        return screenSize
    }
}
