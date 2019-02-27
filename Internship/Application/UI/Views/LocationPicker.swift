//
//  LocationPicker.swift
//  Internship
//
//  Created by sys-246 on 2/27/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit
import MapKit

class LocationPicker: MKMapView {
  func setupView() {
    mapType = .standard
    isZoomEnabled = true
    isScrollEnabled = true
    showsUserLocation = false
    
    backgroundColor = .white
  }
  
  func setInitialPosition(with location: CLLocation) {
    let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    setRegion(region, animated: true)
  }
}
