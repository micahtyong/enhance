//
//  TabsVC.swift
//  Enhance
//
//  Created by Micah Yong on 4/18/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit

class TabsVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let trainingVC = TrainingVC()
        trainingVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        let profileVC = ProfileVC()
        profileVC.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)
        
        let tabBarList = [trainingVC, profileVC]
        
        viewControllers = tabBarList
    }

}
