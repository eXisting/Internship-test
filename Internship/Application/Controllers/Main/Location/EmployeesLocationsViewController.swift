//
//  EmployeesLocationsViewController.swift
//  Internship
//
//  Created by sys-246 on 2/27/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

class EmployeesLocationsViewController: UIViewController {
  private let titleName = "Employees locations"
  
  let mapView = LocationsView()
  private var locationManager: LocationManager!
  
  override func loadView() {
    super.loadView()
    
    view = mapView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    locationManager = LocationManager(with: self)
    locationManager.enableLocationServices()
    
    mapView.locations = DataBaseManager.shared.getEmployees().map({employee in return employee.location!})
    locationManager.requsetDeviceLocation()
    
    title = titleName
  }
}
