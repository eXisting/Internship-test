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
    
  private func onXRotation() {
    transform = transform.rotated(by: CGFloat(xRotation))
  }
  
  private func onYRotation() {
    
  }
}
