//
//  AccelerationViewController.swift
//  Internship
//
//  Created by sys-246 on 3/5/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

class AccelerationViewController: UIViewController {
  private let titleName = "Acceleration"
}

extension AccelerationViewController: SetupableTabBarController {
  func setup() {
    tabBarItem.title = titleName
    
    tabBarItem.selectedImage = UIImage(named: "orientation")
    tabBarItem.image = UIImage(named: "orientation")
  }
}
