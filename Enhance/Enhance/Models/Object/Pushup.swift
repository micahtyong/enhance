//
//  Pushup.swift
//  Enhance
//
//  Created by Micah Yong on 4/19/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import Foundation

class Pushup {
    
    var counter : Int = 0
    var max : Int
    var displayText : String
    let prepare : [String] = ["Ready", "Set", "Go!", "Done!"]
    
    init(upTo max: Int) {
        self.counter = 0
        self.max = max
        self.displayText = ""
    }
    
    func incrementCounter() {
        if isDone() {
            self.displayText = prepare[3]
        } else {
            counter += 1
            self.displayText = "\(counter)"
        }
    }
    
    func isDone() -> Bool {
        return counter > max
    }
    
}
