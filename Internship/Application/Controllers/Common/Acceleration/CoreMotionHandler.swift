//
//  CoreMotionManager.swift
//  Internship
//
//  Created by sys-246 on 3/6/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit
import CoreMotion

class CoreMotionHandler {
  let motionManager = CMMotionManager()
  
  static let shared = CoreMotionHandler()
  
  private init() {
    motionManager.accelerometerUpdateInterval = 0.05
    motionManager.gyroUpdateInterval = 0.05
  }
  
  deinit {
    CoreMotionHandler.shared.motionManager.stopGyroUpdates()
    CoreMotionHandler.shared.motionManager.stopAccelerometerUpdates()
  }
}
