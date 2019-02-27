//
//  LocationPickerController.swift
//  Internship
//
//  Created by sys-246 on 2/27/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

class LocationPickerController: UIViewController {
  var onSelect: ((AnyObject) -> Void)?
  
  private var titleName = "Location"
  
  override func loadView() {
    super.loadView()
    view = LocationPicker()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    title = titleName
  }
}
