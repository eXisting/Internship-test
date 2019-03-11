//
//  KVOArrow.swift
//  Internship
//
//  Created by sys-246 on 3/6/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit
import Darwin

enum Rotation: String {
  case x = "xRotation"
  case y = "yRotation"
}

class KVOArrow: UIImageView {
  @objc dynamic var xRotation: Double = 0
  @objc dynamic var yRotation: Double = 0
  
  deinit {
    removeObserver(self, forKeyPath: "xRotation")
    removeObserver(self, forKeyPath: "yRotation")
  }
  
  func startListening() {
    addObserver(self, forKeyPath: "xRotation", options: [.new], context: nil)
    addObserver(self, forKeyPath: "yRotation", options: [.new], context: nil)
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == Rotation.x.rawValue{ //|| keyPath == Rotation.y.rawValue {
      rotateImage()
    }
  }
  
  private func rotateImage() {
    let newTransform = transform.rotated(by: CGFloat(rad2deg(xRotation) / 1000))
    transform = newTransform
  }
  
  func rad2deg(_ number: Double) -> Double {
    return number * 180 / .pi
  }
}
