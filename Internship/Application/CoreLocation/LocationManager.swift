//
//  LocationManager.swift
//  Internship
//
//  Created by sys-246 on 2/27/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import MapKit
import CoreLocation

class LocationManager {
  private let locationManager = CLLocationManager()
  
  init(with delegate: CLLocationManagerDelegate) {
    locationManager.delegate = delegate
  }
  
  func enableLocationServices() {
    switch CLLocationManager.authorizationStatus() {
      case .notDetermined:
        // Request when-in-use authorization initially
        locationManager.requestWhenInUseAuthorization()
        break
      case .restricted, .denied:
        // Disable location features
        locationManager.requestWhenInUseAuthorization()
        break
      case .authorizedWhenInUse:
        // Enable basic location features
        locationManager.requestWhenInUseAuthorization()
        break
      case .authorizedAlways:
        // Enable any of your app's location features
        break
    }
  }
  
  func requsetDeviceLocation() {
    locationManager.requestLocation()
  }
  
  static func getRegion(by location: CLLocation) -> MKCoordinateRegion {
    let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    return MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
  }
}
