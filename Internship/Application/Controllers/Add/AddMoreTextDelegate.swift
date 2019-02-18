//
//  AddMoreTextDelegate.swift
//  Internship
//
//  Created by sys-246 on 2/14/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

extension AddMoreViewController: UITextFieldDelegate {
  override func viewDidLoad() {
    self.mainView.departmentManager!.delegate = self
    self.mainView.employeeProfileView?.department!.delegate = self
    self.mainView.employeeProfileView?.role?.delegate = self
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return textField != self.mainView.departmentManager &&
      textField != self.mainView.employeeProfileView?.department &&
      textField != self.mainView.employeeProfileView?.role
  }
}
