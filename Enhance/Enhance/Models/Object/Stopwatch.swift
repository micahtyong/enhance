//
//  Stopwatch.swift
//  Enhance
//
//  Created by Micah Yong on 4/21/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
// @source Kiran Kunigiri

import Foundation
import UIKit

// MARK: Stopwatch
class Stopwatch: NSObject {
    
    fileprivate var timer = Timer()
    
    var strHours = "00"
    var strMinutes = "00"
    var strSeconds = "00"
    var strTenthsOfSecond = "00"
    /**
     String representation text shown on the stopwatch (the time)
     */
    var timeText = ""
    
    var numHours = 0
    var numMinutes = 0
    var numSeconds = 0
    var numTenthsOfSecond = 0
    
    fileprivate var startTime = TimeInterval()
    fileprivate var pauseTime = TimeInterval()
    var wasPause = false
    
    @objc func updateTime() {
        // Save the current time
        let currentTime = Date.timeIntervalSinceReferenceDate
        
        // Find the difference between current time and start time to get the time elapsed
        var elapsedTime: TimeInterval = currentTime - startTime
        
        // Calculate the hours of elapsed time
        numHours = Int(elapsedTime / 3600.0)
        elapsedTime -= (TimeInterval(numHours) * 3600)
        
        // Calculate the minutes of elapsed time
        numMinutes = Int(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(numMinutes) * 60)
        
        // Calculate the seconds of elapsed time
        numSeconds = Int(elapsedTime)
        elapsedTime -= TimeInterval(numSeconds)
        
        // Finds out the number of milliseconds to be displayed.
        numTenthsOfSecond = Int(elapsedTime * 100)
        
        // Save the values into strings with the 00 format
        strHours = String(format: "%02d", numHours)
        strMinutes = String(format: "%02d", numMinutes)
        strSeconds = String(format: "%02d", numSeconds)
        strTenthsOfSecond = String(format: "%02d", numTenthsOfSecond)
        timeText = "\(strHours):\(strMinutes):\(strSeconds):\(strTenthsOfSecond)"
    }
    
    
    // MARK: Public functions
    func resetTimer() {
        startTime = Date.timeIntervalSinceReferenceDate
        strHours = "00"
        strMinutes = "00"
        strSeconds = "00"
        strTenthsOfSecond = "00"
        timeText = "\(strHours):\(strMinutes):\(strSeconds):\(strTenthsOfSecond)"
        
    }
    
    /**
     Starts the stopwatch, or resumes it if it was paused
     */
    func start() {
        if !timer.isValid {
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(Stopwatch.updateTime), userInfo: nil, repeats: true)
            
            if wasPause {
                startTime = Date.timeIntervalSinceReferenceDate - startTime
            } else {
                startTime = Date.timeIntervalSinceReferenceDate
            }
        }
    }
    
    /**
     Pause the stopwatch so that it can be resumed later
     */
    func pause() {
        wasPause = true
        
        timer.invalidate()
        pauseTime = Date.timeIntervalSinceReferenceDate
        startTime = pauseTime - startTime
    }
    
    /**
     Stops the stopwatch and erases the current time
     */
    func stop() {
        wasPause = false
        
        timer.invalidate()
        resetTimer()
    }
    
    
    // MARK: Value functions
    
    /**
     Converts the time into hours only and returns it
     */
    func getTimeInHours() -> Int {
        return numHours
    }
    
    /**
     Converts the time into minutes only and returns it
     */
    func getTimeInMinutes() -> Int {
        return numHours * 60 + numMinutes
    }
    
    /**
     Converts the time into seconds only and returns it
     */
    func getTimeInSeconds() -> Int {
        return numHours * 3600 + numMinutes * 60 + numSeconds
    }
    
    /**
     Converts the time into milliseconds only and returns it
     */
    func getTimeInMilliseconds() -> Int {
        return numHours * 3600000 + numMinutes * 60000 + numSeconds * 1000 + numTenthsOfSecond * 100
    }
    
}
