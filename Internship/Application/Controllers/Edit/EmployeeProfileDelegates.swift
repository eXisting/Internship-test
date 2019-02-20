//
//  EmployeeProfileImagePicker.swift
//  Internship
//
//  Created by sys-246 on 2/18/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

extension EmployeeProfileController: ImagePickerDelegate {
  func populateImageView(with image: UIImage?) {
    mainView.profileImage?.image = image
  }
  
  func presentPicker() {
    self.present(self.imagePicker.picker, animated: true, completion: nil)
  }
}
