//
//  PedometerActivity.swift
//  Enhance
//
//  Created by Micah Yong on 4/21/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import Foundation
import CoreMotion

class PedometerActivity {
    
    private let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()
    
    var maxTime : Int
    var currTime : Int = 0
    
    var activityType : String = ""
    var currSteps : Double = 0.0
    
    // So far, our app only supports miles and kilometers
    let milesConversionConstant : Double = 0.0005
    let kiloConversionConstant : Double = 0.000805
    
    init(upTo time: Int) {
        maxTime = time // in seconds
    }
    
    func showDistance(in units: String) -> Double {
        var distance : Double = 0.0
        if units == "miles" {
            distance = currSteps * milesConversionConstant
        } else if units == "kilometers" {
            distance = currSteps * kiloConversionConstant
        } else {
            distance = 0.0
        }
        return roundToXDecimal(x: distance, places: 2)
    }
    
    func roundToXDecimal(x : Double, places : Int) -> Double {
        let roundConstant : Double = Double(places) * 10.0
        return Double(round(roundConstant * x) / roundConstant)
    }
    
    func showSteps() -> Double {
        return currSteps
    }
    
    func showType() -> String {
        return activityType
    }
    
    func startUpdating() {
        if CMMotionActivityManager.isActivityAvailable() {
            startTrackingActivityType()
        }
        if CMPedometer.isStepCountingAvailable() {
            startCountingSteps()
        }
    }
    
    func startCountingSteps() {
        pedometer.startUpdates(from: Date()) {
            [weak self] pedometerData, error in
            guard let pedometerData = pedometerData, error == nil else { return }
            
            DispatchQueue.main.async {
                self?.currSteps = pedometerData.numberOfSteps.doubleValue
            }
        }
    }
    
    func startTrackingActivityType() {
        activityManager.startActivityUpdates(to: OperationQueue.main) {
            [weak self] (activity: CMMotionActivity?) in
            
            guard let activity = activity else { return }
            DispatchQueue.main.async {
                if activity.walking {
                    self?.activityType = "Walking"
                } else if activity.stationary {
                    self?.activityType = "Stationary"
                } else if activity.running {
                    self?.activityType = "Running"
                } else if activity.automotive {
                    self?.activityType = "Automotive"
                }
            }
        }
    }
    
    func isDone() -> Bool {
        return currTime > maxTime
    }
    
    func incrementTime() {
        currTime += 1
    }
    
}