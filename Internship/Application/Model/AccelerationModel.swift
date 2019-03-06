//
//  AccelerationModel.swift
//  Internship
//
//  Created by sys-246 on 3/6/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit
import CoreMotion

class AccelerationModel {
  func startObserving(accelerationCallback: @escaping (CMAccelerometerData) -> Void, gyroscopeCallback: @escaping (CMGyroData) -> Void) {
    CoreMotionHandler.shared.motionManager.startAccelerometerUpdates(to: OperationQueue.main) {
      (data, error) in
      guard let acceleration = data else {
        return
      }
      
      accelerationCallback(acceleration)
    }
    
    CoreMotionHandler.shared.motionManager.startGyroUpdates(to: OperationQueue.main) {
      (data, error) in
      guard let gyro = data else {
        return
      }
      
      gyroscopeCallback(gyro)
    }
  }
}
