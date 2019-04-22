//
//  Pushup.swift
//  Enhance
//
//  Created by Micah Yong on 4/19/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import Foundation

class VisionActivity {
    
    var max : Int
    var curr : Int = 0
    var confidenceLevel : Double = 92.4
    
    var goodFrames : Double = 0.0
    var totalFrames : Double = 0.0
    
    var displayText : String
    let prepare : [String] = ["Ready?", "Set?", "Go!", "Done!"]
    
    init(upTo max: Int) {
        self.max = max
        self.displayText = ""
    }
    
    func calibrateConfidence(isGood : Bool) {
        if isGood {
            goodFrames += 1.0
        }
        totalFrames += 1.0
    }
    
    func showConfidence() -> Double {
        confidenceLevel = (goodFrames / totalFrames) * 100
        confidenceLevel.round()
        return confidenceLevel
    }
    
    func increment() {
        curr += 1
    }
    
    func isDone() -> Bool {
        return curr > max
    }
    
    func ready() -> String {
        return prepare[0]
    }
    
    func set() -> String {
        return prepare[1]
    }
    
    func go() -> String {
        return prepare[2]
    }
    
}
