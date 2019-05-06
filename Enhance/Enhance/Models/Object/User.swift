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
    
    var energyPoints: Double
    
    var strengthTotal: Double
    var staminaTotal: Double
    var coreTotal: Double
    
    init(name: String, deviceID: String) {
        self.name = name
        self.deviceID = deviceID
        self.energyPoints = 0.0
        
        self.strengthTotal = 0.0
        self.staminaTotal = 0.0
        self.coreTotal = 0.0
    }
    
    init(name: String, deviceID: String, energy: Double, strength: Double, stamina: Double, core: Double) {
        self.name = name
        self.deviceID = deviceID
        self.energyPoints = energy
        
        self.strengthTotal = strength
        self.staminaTotal = stamina
        self.coreTotal = core
    }
    
    func strengthLevel() -> Double {
        return (strengthTotal / 50.0).rounded()
    }
    
    func staminaLevel() -> Double {
        return (staminaTotal / 2.0).rounded()
    }
    
    func coreLevel() -> Double {
        return (coreTotal / 70.0).rounded()
    }
    
    func addToTotal(amount : Double) {
        self.energyPoints += amount
    }
    
    func addToStrength(amount : Double) {
        self.strengthTotal += amount
    }
    
    func addToStamina(amount : Double) {
        self.staminaTotal += amount
    }
    
    func addToCore(amount : Double) {
        self.coreTotal += amount
    }
    
}
