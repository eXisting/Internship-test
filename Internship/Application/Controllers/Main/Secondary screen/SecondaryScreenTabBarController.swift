//
//  SecondaryScreenTabViewController.swift
//  Internship
//
//  Created by sys-246 on 3/5/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

protocol SetupableTabBarController {
  func setup()
}

class SecondaryScreenTabBarController: UITabBarController {
  private let employeesLocationTab = EmployeesLocationsViewController()
  private let accelerationTab = AccelerationViewController()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let controllers = [accelerationTab, employeesLocationTab]
    controllers.forEach {
      controller in
      (controller as? SetupableTabBarController)?.setup()
    }
    
    setViewControllers(controllers, animated: true)
    view.backgroundColor = .white
  }
}
