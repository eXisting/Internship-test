//
//  AnnotationView.swift
//  Internship
//
//  Created by sys-246 on 2/27/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import MapKit

class EmployeeAnnotation: NSObject, MKAnnotation {
  
  var employee: Employee
  
  var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: employee.location!.latitude, longitude: employee.location!.longitude)
  }
  
  init(employee: Employee) {
    self.employee = employee
    super.init()
  }
  
  var title: String? {
    return employee.name
  }
  
  var subtitle: String? {
    return employee.location?.name
  }
}
