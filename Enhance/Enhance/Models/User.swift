//
//  User.swift
//  Enhance
//
//  Created by Micah Yong on 4/14/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import Foundation

class User {
    
    var name: String
    var deviceID: String
    var points: Int
    
    init(name: String, deviceID: String) {
        self.name = name
        self.deviceID = deviceID
        self.points = 0
    }
    
}
