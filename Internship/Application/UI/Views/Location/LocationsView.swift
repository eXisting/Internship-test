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
  
  func setInitialPosition(with location: CLLocation) {
    setRegion(LocationManager.getRegion(by: location), animated: true)
  }
  
  func placeUserPin(_ location: CLLocation) {
    let userAnnotation = MKPointAnnotation()
    userAnnotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    userAnnotation.title = "You"
    addAnnotation(userAnnotation)
  }
  
  private func placeExistingAnnotations() {
    if let passedEmployees = employees {
      for employee in passedEmployees {
        let annotation = EmployeeAnnotation(employee: employee)
//        annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
//        annotation.title = location.name
        addAnnotation(annotation)
      }
    }
  }
}

