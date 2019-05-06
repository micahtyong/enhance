//
//  OnboardVC.swift
//  Enhance
//
//  Created by Micah Yong on 5/5/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit
import paper_onboarding

class OnboardVC: UIViewController {
    
    let backButton : BackButton = BackButton()
    let skipButton : SkipButton = SkipButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnboarding()
        setupBackButton()
        setupSkipButton()
    }
    
    func setupSkipButton() {
        skipButton.addTarget(self, action: #selector(getStarted), for: .touchUpInside)
        
        self.view.addSubview(skipButton)
        self.view.bringSubviewToFront(skipButton)
        
        skipButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        skipButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func getStarted(_ sender:UIButton) {
        sender.pulse()
        let diagnoseVC = DiagnoseVC()
        diagnoseVC.hero.isEnabled = true
        diagnoseVC.hero.modalAnimationType = .selectBy(presenting: .fade, dismissing: .fade)
        self.present(diagnoseVC, animated: true, completion: nil)
    }
    
    func setupBackButton() {
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        self.view.addSubview(backButton)
        self.view.bringSubviewToFront(backButton)
        
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        backButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func goBack(_ sender:UIButton) {
        sender.pulse()
        dismiss(animated: true, completion: nil)
    }
    
    func setupOnboarding() {
        let onboarding = PaperOnboarding(pageViewBottomConstant: 3)
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
        // add constraints
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
    }

}

// Mark: - PaperOnboardingDelegate and Data Source

extension OnboardVC : PaperOnboardingDelegate, PaperOnboardingDataSource {
    
    // Delegate
    func onboardingWillTransitonToIndex(_ index: Int) { }
    
    func onboardingDidTransitonToIndex(_: Int) { }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
        // Configure Image
        item.descriptionLabel?.translatesAutoresizingMaskIntoConstraints = false
        item.descriptionLabel?.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    
    // Data Source
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return [
            OnboardingItemInfo(informationImage: UIImage(named: "onboarding1")!,
                               title: "Improve your physique",
                               description: "Train with 3 essential exercises that improve\nyour everyday strength, stamina, and core.",
                               pageIcon: UIImage(named: "enhanceLogo")!,
                               color: UIColor.white,
                               titleColor: UIColor.black,
                               descriptionColor: UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1),
                               titleFont: UIFont(name: "HelveticaNeue-Medium", size: 20)!,
                               descriptionFont: UIFont(name: "HelveticaNeue-Medium", size: 14)!),
            
            OnboardingItemInfo(informationImage: UIImage(named: "onboarding2")!,
                               title: "Stay accountable",
                               description: "Enhance is more than a fitness training plan.\nIt uses frameworks like OpenPose\nand CoreMotion to verify your activity\n and correct your form.",
                               pageIcon: UIImage(named: "enhanceLogo")!,
                               color: UIColor.white,
                               titleColor: UIColor.black,
                               descriptionColor: UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1),
                               titleFont: UIFont(name: "HelveticaNeue-Medium", size: 20)!,
                               descriptionFont: UIFont(name: "HelveticaNeue-Medium", size: 14)!),
            
            OnboardingItemInfo(informationImage: UIImage(named: "onboarding3")!,
                               title: "Track your progress",
                               description: "Enhance customizes a training program, analyzes your performance, and tracks your improvement.",
                               pageIcon: UIImage(named: "enhanceLogo")!,
                               color: UIColor.white,
                               titleColor: UIColor.black,
                               descriptionColor: UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1),
                               titleFont: UIFont(name: "HelveticaNeue-Medium", size: 20)!,
                               descriptionFont: UIFont(name: "HelveticaNeue-Medium", size: 14)!)
            ][index]
    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
}
