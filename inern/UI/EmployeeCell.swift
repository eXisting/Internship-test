//
//  EmployeeCell.swift
//  inern
//
//  Created by Andrey Popazov on 2/11/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

class EmployeeCell: UITableViewCell {
  var name: UILabel?
  var role: UILabel?
  var photo: UIImageView?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    laidOutImage()
    laidOutLabels()
    
    accessoryType = .disclosureIndicator
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func laidOutImage() {
    let photoOrign = CGPoint.zero
    let photoSize = CGSize(width: self.frame.width / 4, height: self.frame.height)
    let photoFrame = CGRect.init(origin: photoOrign, size: photoSize)
    
    photo = UIImageView(frame: photoFrame)
    photo?.contentMode = .scaleAspectFit
    
    addSubview(photo!)
  }
  
  private func laidOutLabels() {
    let halfHeight = MainTableViewController.defaultRowHeight / 2
    
    let nameOrign = CGPoint.init(x: self.frame.width / 3, y: 0)
    let roleOrign = CGPoint.init(x: self.frame.width / 3, y: halfHeight)

    let labelSize = CGSize(width: self.frame.width / 2, height: halfHeight)
    
    let nameFrame = CGRect.init(origin: nameOrign, size: labelSize)
    let roleFrame = CGRect.init(origin: roleOrign, size: labelSize)
    
    name = UILabel(frame: nameFrame)
    role = UILabel(frame: roleFrame)
    
    name!.textColor = .black
    name!.font = UIFont.boldSystemFont(ofSize: 18)
    name!.textAlignment = .left
    
    role!.textColor = .black
    role!.font = UIFont.boldSystemFont(ofSize: 16)
    role!.textAlignment = .left
    
    addSubview(name!)
    addSubview(role!)
  }
}
