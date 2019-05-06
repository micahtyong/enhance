//
//  TabsVC.swift
//  Enhance
//
//  Created by Micah Yong on 4/18/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit
import SwipeableTabBarController

class TabsVC: SwipeableTabBarController {
    
    var user : User = Enhance.user
    let trainingVC = TrainingVC()
    let profileVC = ProfileVC()

    override func viewDidLoad() {
        super.viewDidLoad()
        user = Enhance.user
        
        // Tab Bar VC's
        trainingVC.tabBarItem = UITabBarItem(title: "Train", image: UIImage(named: "trophy"), tag: 0)
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "happy"), tag: 1)
        let tabBarList = [trainingVC, profileVC]
        viewControllers = tabBarList
        
        // Misc.
        swipeAnimatedTransitioning?.animationType = SwipeAnimationType.sideBySide
        
    }

}
