//
//  SelectableGeneralCell.swift
//  Internship
//
//  Created by sys-246 on 2/20/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

class SelectableGeneralCell: GeneralCell {
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    self.accessoryType = selected ? .checkmark : .none
  }
}
