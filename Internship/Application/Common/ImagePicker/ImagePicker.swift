//
//  ImagePicker.swift
//  Internship
//
//  Created by sys-246 on 2/20/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

class ImagePicker: NSObject {
  let picker = UIImagePickerController()
  
  var delegate: ImagePickerDelegate!
  
  func setupPicker(delegate: ImagePickerDelegate) {
    self.delegate = delegate
    
    picker.delegate = self
    picker.sourceType = UIImagePickerController.SourceType.photoLibrary
    picker.allowsEditing = false
  }
}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let chosenImage = info[UIImagePickerController.InfoKey.editedImage]
    self.delegate.populateImageView(with: chosenImage as? UIImage)
    
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  func openGallary()
  {
    picker.sourceType = UIImagePickerController.SourceType.photoLibrary
    picker.allowsEditing = true
    self.delegate.presentPicker()
  }
}
