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
}

extension EmployeesLocationsViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
    let visibleRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
    self.mapView.setRegion(self.mapView.regionThatFits(visibleRegion), animated: true)
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MKUserLocation { return nil }
    
    let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: self.annotationViewIdentifier) as? EmployeeAnnotationView
    annotationView?.annotation = annotation
    annotationView?.delegate = pathSearchController
    
    return annotationView
  }
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let renderer = MKPolylineRenderer(overlay: overlay)
    renderer.strokeColor = UIColor.black
    renderer.lineWidth = 4.0
    
    return renderer
  }
}
