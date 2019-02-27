//
//  EmployeesLocationsViewController.swift
//  Internship
//
//  Created by sys-246 on 2/27/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit
import MapKit

class EmployeesLocationsViewController: UIViewController {
  private let titleName = "Employees locations"
  let annotationViewIdentifier = "Employee info"
  let userIdentifier = "User"

  let mapView = LocationsView()
  private var locationManager: LocationManager!
  
  override func loadView() {
    super.loadView()
    
    view = mapView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.delegate = self
    mapView.setupView()
    
    locationManager = LocationManager(with: self)
    locationManager.enableLocationServices()
    
    self.mapView.register(EmployeeAnnotationView.self, forAnnotationViewWithReuseIdentifier: annotationViewIdentifier)
    self.mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: userIdentifier)
    
    mapView.employees = DataBaseManager.shared.getEmployees()
    
    title = titleName
  }
}
