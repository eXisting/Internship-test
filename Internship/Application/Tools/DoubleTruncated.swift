//
//  DoubleTruncated.swift
//  Internship
//
//  Created by sys-246 on 3/6/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

extension Double
{
  func truncate(places : Int) -> Double
  {
    return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
  }
}
