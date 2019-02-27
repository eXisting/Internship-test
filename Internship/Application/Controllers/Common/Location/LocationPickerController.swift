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
  
  private var locationManager: LocationManager!
  
  var pickerView: LocationPicker!
  
  override func loadView() {
    super.loadView()
    
    pickerView = LocationPicker()
    
    view = pickerView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = titleName
    
    locationManager = LocationManager(with: self)
    locationManager.enableLocationServices()

    pickerView.setupView()
    locationManager.requsetDeviceLocation()
        
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(save))
  }
  
  @objc func save() {
    onSelect?(titleName as AnyObject)
    
    self.navigationController?.popViewController(animated: true)
  }
}
