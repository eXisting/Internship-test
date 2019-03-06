//
//  KVCLabel.swift
//  Internship
//
//  Created by sys-246 on 3/6/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

class KVCLabel: UILabel {
  @objc dynamic var kvcText = "" {
    willSet {
      text = newValue
    }
  }
}
