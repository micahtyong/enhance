//
//  TabsVC.swift
//  Enhance
//
//  Created by Micah Yong on 4/18/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit

class TabsVC: UITabBarController {
    
    var user : User = Enhance.user
    let trainingVC = TrainingVC()
    let profileVC = ProfileVC()

    override func viewDidLoad() {
        super.viewDidLoad()
        user = Enhance.user
        trainingVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        profileVC.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)
        let tabBarList = [trainingVC, profileVC]
        viewControllers = tabBarList
    }

}
