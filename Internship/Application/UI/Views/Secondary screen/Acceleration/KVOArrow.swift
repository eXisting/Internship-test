//
//  KVOArrow.swift
//  Internship
//
//  Created by sys-246 on 3/6/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

enum Rotation: String {
  case x = "onXRotation"
  case y = "onYRotation"
}

class KVOArrow: UIImageView {
  @objc dynamic var xRotation: Double = 0
  @objc dynamic var yRotation: Double = 0
  
  func assignObservers() {
    addObserver(self, forKeyPath: "xRotation", options: [.new], context: nil)
    addObserver(self, forKeyPath: "yRotation", options: [.new], context: nil)
  }
  
  deinit {
    deassignObservers()
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "xRotation" || keyPath == "yRotation" {
      rotate()
    }
  }
  
  func deassignObservers() {
    removeObserver(self, forKeyPath: "xRotation")
    removeObserver(self, forKeyPath: "yRotation")
  }
  
  private func rotate() {
    var transformY = CATransform3DIdentity
    var transformX = CATransform3DIdentity
    transformY.m34 = 1.0 / 500.0
    transformX.m34 = 1.0 / 500.0
    
    let xAngle = rad2deg(xRotation)
    let yAngle = rad2deg(yRotation)
    print("X: \(xAngle)")
    print("Y: \(yAngle)")
    transformY = CATransform3DRotate(transformY, yAngle, 1, 0, 0)
    transformX = CATransform3DRotate(transformY, xAngle, 0, 0, 1)
    
    let concat = CATransform3DConcat(transformX, transformY)
    layer.transform = concat
  }
  
  func rad2deg(_ number: Double) -> CGFloat {
    return CGFloat(number * 180 / .pi)
  }
}
