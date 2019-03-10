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
  private var onAccelerationEvent: (Double, Double, Double) -> Void
  private var onGyroEvent: (Double, Double, Double) -> Void

  var orientation: String = "up"
  
  init(accelerationCallback: @escaping (Double, Double, Double) -> Void, gyroscopeCallback: @escaping (Double, Double, Double) -> Void) {
    onAccelerationEvent = accelerationCallback
    onGyroEvent = gyroscopeCallback
  }
  
  func startObserving() {
    CoreMotionHandler.shared.motionManager.startAccelerometerUpdates(to: OperationQueue.main) {
      [weak self] (data, error) in
      guard let acceleration = data else {
        return
      }
      
      self?.process(acceleration)
    }
    
    CoreMotionHandler.shared.motionManager.startGyroUpdates(to: OperationQueue.main) {
      [weak self] (data, error) in
      guard let gyro = data else {
        return
      }
      
      self?.process(gyro)
    }
  }
  
  private func process(_ gearData: CMLogItem) {
    if let gyroData = gearData as? CMGyroData {
      let x = (gyroData.rotationRate.x).truncate(places: 2)
      let y = (gyroData.rotationRate.y).truncate(places: 2)
      let z = (gyroData.rotationRate.z).truncate(places: 2)
      
      var text = orientation
      if y > 0.6 {
        text = "right"
      } else if y < -0.6 {
        text = "left"
      } else if x > 0.6 {
        text = "up"
      } else if x < -0.6 {
        text = "down"
      }
      
      if text != orientation {
      }
      
      onGyroEvent(x, y, z)
    } else if let accelerationData = gearData as? CMAccelerometerData {
      let x = (accelerationData.acceleration.x).truncate(places: 2)
      let y = (accelerationData.acceleration.y).truncate(places: 2)
      let z = (accelerationData.acceleration.z).truncate(places: 2)
      
      onAccelerationEvent(x, y, z)
    }
  }
}


extension Notification.Name {
  static let OrientationChanged = Notification.Name.init("OritentationChanged")
}
