//
//  LocationPickerController.swift
//  Internship
//
//  Created by sys-246 on 2/27/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit
import CoreData

class LocationPickerController: UIViewController {
  var onSelect: (([String: Any]) -> Void)?
  
  private var titleName = "Location"
  
  private var locationManager: LocationManager!
  
  let pickerView = LocationPicker()
  
  override func loadView() {
    super.loadView()
    
    view = pickerView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = titleName
    
    locationManager = LocationManager(with: self)
    locationManager.enableLocationServices()
    locationManager.requsetDeviceLocation()

    pickerView.setupView()
            
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(save))
  }
  
  @objc func save() {
    guard let data = pickerView.getLocationData() else {
      AlertController.showConfirm(for: self, "Error", "Choose location to add to your data!!", .alert, {_ in })
      return
    }
    
    onSelect?(data)
    
    self.navigationController?.popViewController(animated: true)
  }
}
