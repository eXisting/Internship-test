//
//  SectionData.swift
//  Internship
//
//  Created by sys-246 on 2/18/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit
import CoreData

struct SectionData {
  var section: Int!
  var isCollapsed = false
  
  var department: Department
  var employees: [Employee]
  
  init(_ department: Department) {
    self.department = department
    employees = department.employee?.allObjects as! [Employee]
  }
}
