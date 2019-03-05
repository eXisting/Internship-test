//
//  SearchPath.swift
//  Internship
//
//  Created by sys-246 on 2/28/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import MapKit

protocol SearchingPath: class {
  func searchPath(to destination: MKMapItem)
}

class PathSearchController: SearchingPath {
  weak var mapView: MKMapView?
  
  init(_ mapView: MKMapView) {
    self.mapView = mapView
  }
  
  func searchPath(to destination: MKMapItem) {
    let directionRequest = MKDirections.Request()
    directionRequest.source = MKMapItem.forCurrentLocation()
    directionRequest.destination = destination
    directionRequest.transportType = .automobile
    
    let directions = MKDirections(request: directionRequest)
    
    directions.calculate {
      (response, error) -> Void in
      
      guard let response = response else {
        if let error = error {
          print("Error during path search: \(error)")
        }
        
        return
      }
      
      let route = response.routes[0]
      self.mapView?.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
      
      let rect = route.polyline.boundingMapRect
      self.mapView?.setRegion(MKCoordinateRegion(rect), animated: true)
    }
  }
}
