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
  
  private let accelerationLabel = KVCLabel()
  private let gyroLabel = KVCLabel()
  private let oriantationLabel = KVCLabel()
  
  private let arrowObject = KVOArrow()
  
  deinit {
    removeObserver(arrowObject, forKeyPath: "xRotation")
    removeObserver(arrowObject, forKeyPath: "yRotation")
  }
  
  func setup() {
    laidOutViews()
    customizeViews()
  }
  
  func onAccelerationChange(data: CMAccelerometerData) {
    let x = (data.acceleration.x * 100).truncate(places: 2)
    let y = (data.acceleration.y * 100).truncate(places: 2)
    let z = (data.acceleration.z * 100).truncate(places: 2)

    accelerationLabel.setValue("Accelerometr: X: \(x) Y: \(y) Z: \(z)", forKey: "kvcText")
    
    arrowObject.xRotation = data.acceleration.x
    arrowObject.yRotation = data.acceleration.y
  }
  
  func onGyroscopeChange(data: CMGyroData) {
    let x = (data.rotationRate.x * 100).truncate(places: 2)
    let y = (data.rotationRate.y * 100).truncate(places: 2)
    let z = (data.rotationRate.z * 100).truncate(places: 2)
    
    gyroLabel.setValue("Gyro: X: \(x) Y: \(y) Z: \(z)", forKey: "kvcText")
    
    var text = oriantationLabel.text
    if y > 60 {
      text = "right"
    } else if y < -60 {
      text = "left"
    } else if x > 60 {
      text = "up"
    } else if x < -60 {
      text = "down"
    }
    
    oriantationLabel.setValue(text, forKey: "kvcText")
  }
  
  private func laidOutViews() {
    addSubview(labelsStack)
    addSubview(arrowObject)

    labelsStack.addArrangedSubview(oriantationLabel)
    labelsStack.addArrangedSubview(accelerationLabel)
    labelsStack.addArrangedSubview(gyroLabel)
    
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
    oriantationLabel.adjustsFontSizeToFitWidth = true
    gyroLabel.adjustsFontSizeToFitWidth = true
    accelerationLabel.adjustsFontSizeToFitWidth = true
    
    labelsStack.alignment = .fill
    labelsStack.distribution = .fillEqually
    labelsStack.axis = .vertical

    arrowObject.image = UIImage(named: "arrowUp")
  }
}
