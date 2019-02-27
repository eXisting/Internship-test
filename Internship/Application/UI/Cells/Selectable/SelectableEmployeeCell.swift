//
//  SelectableEmployeeCell.swift
//  Internship
//
//  Created by sys-246 on 2/19/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

class SelectableEmployeeCell: EmployeeCell {
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    self.accessoryType = selected ? .checkmark : .none
  }
}
