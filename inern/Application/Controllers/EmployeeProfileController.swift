//
//  EmployeeProfileController.swift
//  inern
//
//  Created by Andrey Popazov on 2/11/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

class EmployeeProfileController: UIViewController {
  private var mainView: EmployeeProfile!
  
  override func loadView() {
    super.loadView()
    self.title = "Employee profile"
    
    mainView = EmployeeProfile(frame: self.view.frame)
    self.view = mainView
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
  }
  
  private func setupFields() {
    // (self.view as! EmployeeProfile)
  }
    
  @objc func save() {
    print("Saved")
  }
}
