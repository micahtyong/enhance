//
//  Engage.swift
//  Enhance
//
//  Created by Micah Yong on 4/17/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit


struct Enhance {
    static let customOrange = UIColor(red: 0.98, green: 0.65, blue: 0.01, alpha: 1)
    static let customWhite = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    static let deviceID : String = UIDevice.current.identifierForVendor?.uuidString ?? "No device available"
    static var user = User(name: "Micah", deviceID: Enhance.deviceID)
}


