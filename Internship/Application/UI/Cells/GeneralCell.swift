//
//  GeneralCell.swift
//  Internship
//
//  Created by sys-246 on 2/18/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit
import CoreData

class GeneralCell: UITableViewCell {
  var name: UILabel?
  
  var content: NSManagedObject!
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    laidOutLabels()
    
    selectionStyle = .none
    accessoryType = .disclosureIndicator
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func laidOutLabels() {
    name = UILabel(frame: CGRect(origin: CGPoint(x: self.frame.width * 0.1, y: 0), size: CGSize(width: self.frame.width * 0.9, height: self.frame.height)))
    
    name!.textColor = .black
    name!.font = UIFont.boldSystemFont(ofSize: 18)
    name!.textAlignment = .left
    
    addSubview(name!)
  }
}
