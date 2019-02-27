//
//  EmployeeProfileImagePicker.swift
//  Internship
//
//  Created by sys-246 on 2/18/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

extension EmployeeProfileController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return textField != self.mainView.department &&
      textField != self.mainView.role &&
      textField != self.mainView.location
  }
}

extension EmployeeProfileController: ImagePickerDelegate {
  func populateImageView(with image: UIImage?) {
    mainView.profileImage?.image = image
  }
  
  func presentPicker() {
    self.present(self.imagePicker.picker, animated: true, completion: nil)
  }
}
