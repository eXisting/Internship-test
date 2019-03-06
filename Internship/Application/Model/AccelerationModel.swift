//
//  AccelerationModel.swift
//  Internship
//
//  Created by sys-246 on 3/6/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit
import CoreMotion

class AccelerationModel: NSObject {
  @objc dynamic var accelerationData = CMAccelerometerData()
  @objc dynamic var gyroscopeData = CMGyroData()
  
  func addObservers(accelerationCallback: @escaping (CMAccelerometerData) -> Void, gyroscopeCallback: @escaping (CMGyroData) -> Void) {
    CoreMotionHandler.shared.motionManager.startAccelerometerUpdates(to: OperationQueue.main) {
      [weak self] (data, error) in
      guard let acceleration = data else {
        return
      }
      
      self?.accelerationData = acceleration
      accelerationCallback(self!.accelerationData)
    }
    
    CoreMotionHandler.shared.motionManager.startGyroUpdates(to: OperationQueue.main) {
      [weak self] (data, error) in
      guard let gyro = data else {
        return
      }
      
      self?.gyroscopeData = gyro
      gyroscopeCallback(self!.gyroscopeData)
    }
  }
}
