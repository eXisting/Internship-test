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
  var name: String?
  var longitude: Double?
  var latitude: Double?
  
  weak var location: Location? {
    didSet {
      name = location?.name
      longitude = location?.longitude
      latitude = location?.latitude
      
      setInitialPosition(with: CLLocation(latitude: latitude!, longitude: longitude!))
      setExistingAnnotation()
    }
  }
  
  func setupView() {
    mapType = .standard
    isZoomEnabled = true
    isScrollEnabled = true
    showsUserLocation = false
    
    backgroundColor = .white
    
    addTargets()
  }
  
  func setInitialPosition(with location: CLLocation) {
    let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    setRegion(region, animated: true)
  }
  
  func getLocationData() -> [String: Any]? {
    guard let title = name, let long = longitude, let lat = latitude else {
      return nil
    }
    
    return ["name": title, "longitude": long, "latitude": lat]
  }
  
  private func setExistingAnnotation() {
    let annotation = MKPointAnnotation()
    annotation.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
    annotation.title = name
    addAnnotation(annotation)
  }
  
  private func addTargets() {
    let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotationAction))
    recognizer.minimumPressDuration = 2.0
    
    self.addGestureRecognizer(recognizer)
  }
  
  @objc func addAnnotationAction(gestureRecognizer: UILongPressGestureRecognizer) {
    if gestureRecognizer.state == UIGestureRecognizer.State.began {
      removeAnnotations(self.annotations)
      
      let touchPoint = gestureRecognizer.location(in: self)
      let newCoordinates = self.convert(touchPoint, toCoordinateFrom: self)
      let annotation = MKPointAnnotation()
      annotation.coordinate = newCoordinates
      
      CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude), completionHandler: {
        [weak self] (placemarks, error) -> Void in
        if error != nil {
          print("Reverse geocoder failed with error" + error!.localizedDescription)
          return
        }
        
        guard let placemark = placemarks?.first else {
          print("No placemarks!")
          return
        }
        
        if let thoroughfare = placemark.thoroughfare,
          let subThoroughfare = placemark.subThoroughfare {
          annotation.title = thoroughfare + ", " + subThoroughfare
          annotation.subtitle = placemark.subLocality
        } else {
          annotation.title = placemark.subLocality
        }
        
        self?.addAnnotation(annotation)
        
        self?.name = annotation.title
        self?.longitude = newCoordinates.longitude
        self?.latitude = newCoordinates.latitude
      })
    }
  }
}
