//
//  LocationsView.swift
//  Internship
//
//  Created by sys-246 on 2/27/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import MapKit

class LocationsView: MKMapView {
  var employees: [Employee]? {
    didSet {
      placeExistingAnnotations()
    }
  }
  
  func setupView() {
    mapType = .standard
    isZoomEnabled = true
    isScrollEnabled = true
    showsUserLocation = true
    
    backgroundColor = .white
  }
  
  private func placeExistingAnnotations() {
    if let passedEmployees = employees {
      for employee in passedEmployees {
        let annotation = EmployeeAnnotation(employee: employee)
        addAnnotation(annotation)
      }
    }
  }
}

