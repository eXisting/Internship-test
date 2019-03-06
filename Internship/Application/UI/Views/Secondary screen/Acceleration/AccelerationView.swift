//
//  AccelerationView.swift
//  Internship
//
//  Created by sys-246 on 3/6/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit
import CoreMotion

class AccelerationView: UIView {
  private let labelsStack = UIStackView()
  
  private let xLabel = KVCLabel()
  private let yLabel = KVCLabel()
  private let zLabel = KVCLabel()
  private let gyroData = KVCLabel()

  private let arrowObject = UIImageView()
  
  func setup() {
    laidOutViews()
    customizeViews()
  }
  
  func onAccelerationChange(data: CMAccelerometerData) {
    xLabel.setValue("X: \(data.acceleration.x * 100)", forKey: "kvcText")
    yLabel.setValue("Y: \(data.acceleration.y * 100)", forKey: "kvcText")
    zLabel.setValue("Z: \(data.acceleration.z * 100)", forKey: "kvcText")
  }
  
  func onGyroscopeChange(data: CMGyroData) {
    gyroData.setValue("Gyro: \(data.rotationRate.x * 100) \(data.rotationRate.y * 100) \(data.rotationRate.z * 100)", forKey: "kvcText")
  }
  
  private func laidOutViews() {
    addSubview(labelsStack)
    addSubview(arrowObject)

    labelsStack.addArrangedSubview(xLabel)
    labelsStack.addArrangedSubview(yLabel)
    labelsStack.addArrangedSubview(zLabel)
    labelsStack.addArrangedSubview(gyroData)
    
    labelsStack.translatesAutoresizingMaskIntoConstraints = false
    arrowObject.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint(item: arrowObject, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: arrowObject, attribute: .height, relatedBy: .equal, toItem: arrowObject, attribute: .width, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: arrowObject, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0).isActive = true
    NSLayoutConstraint(item: arrowObject, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -16).isActive = true
    
    NSLayoutConstraint(item: labelsStack, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 100).isActive = true
    NSLayoutConstraint(item: labelsStack, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: labelsStack, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.85, constant: 0).isActive = true
    NSLayoutConstraint(item: labelsStack, attribute: .bottom, relatedBy: .equal, toItem: arrowObject, attribute: .top, multiplier: 1, constant: -16).isActive = true
  }
  
  private func customizeViews() {
    xLabel.adjustsFontSizeToFitWidth = true
    yLabel.adjustsFontSizeToFitWidth = true
    zLabel.adjustsFontSizeToFitWidth = true
    gyroData.adjustsFontSizeToFitWidth = true

    labelsStack.alignment = .fill
    labelsStack.distribution = .fillEqually
    labelsStack.axis = .vertical

    arrowObject.image = UIImage(named: "arrowUp")
  }
}
