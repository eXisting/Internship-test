//
//  EmployeesLocationsViewControllerDelegates.swift
//  Internship
//
//  Created by sys-246 on 2/27/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import MapKit

extension EmployeesLocationsViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error.localizedDescription)
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      self.mapView.setInitialPosition(with: location)
      self.mapView.placeUserPin(location)
    }
  }
}
