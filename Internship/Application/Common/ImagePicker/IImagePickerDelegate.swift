//
//  IImagePickerDelegate.swift
//  Internship
//
//  Created by sys-246 on 2/20/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

protocol ImagePickerDelegate {
  func populateImageView(with image: UIImage?)
  func presentPicker()
}
