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
  private let titleName = "Locations"
  private var locationManager: LocationManager!
  
  let annotationViewIdentifier = "Employee info"
  let userIdentifier = "User"

  let mapView = LocationsView()
  var pathSearchController: PathSearchController!
  
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
    
    pathSearchController = PathSearchController(self.mapView)
    
//    self.mapView.register(EmployeeAnnotationView.self, forAnnotationViewWithReuseIdentifier: annotationViewIdentifier)
//    self.mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: userIdentifier)
    
    mapView.employees = DataBaseManager.shared.getEmployees()
    
    title = titleName
  }
}

extension EmployeesLocationsViewController: SetupableTabBarController {
  func setup() {
    tabBarItem.title = titleName
    
    tabBarItem.selectedImage = UIImage(named: "location")
    tabBarItem.image = UIImage(named: "location")
  }
}
