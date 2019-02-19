//
//  ReusableHeader.swift
//  Internship
//
//  Created by sys-246 on 2/14/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

protocol ExandableHeaderViewDelegate {
  func toogleExpand(for header: ReusableHeader, section: Int)
}

class ReusableHeader: UITableViewHeaderFooterView {  
  var data: SectionData! {
    didSet {
      textLabel?.text = data.department.name
    }
  }
  
  var delegate: ExandableHeaderViewDelegate!
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSelectHeader)))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func onSelectHeader(recognizer: UITapGestureRecognizer) {
    let cell = recognizer.view as! ReusableHeader
    delegate.toogleExpand(for: cell, section: cell.data.section)
  }
}
