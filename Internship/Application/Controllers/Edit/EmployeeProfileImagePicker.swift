//
//  EmployeeProfileImagePicker.swift
//  Internship
//
//  Created by sys-246 on 2/18/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

extension EmployeeProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [AnyHashable: Any]) {
    let chosenImage = info[UIImagePickerController.InfoKey.editedImage]
    mainView.profileImage?.image = chosenImage as? UIImage
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  func openCamera()
  {
    if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
    {
      imagePicker.sourceType = UIImagePickerController.SourceType.camera
      imagePicker.allowsEditing = true
      self.present(imagePicker, animated: true, completion: nil)
    }
    else
    {
      let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  func openGallary()
  {
    imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
    imagePicker.allowsEditing = true
    self.present(imagePicker, animated: true, completion: nil)
  }
}
