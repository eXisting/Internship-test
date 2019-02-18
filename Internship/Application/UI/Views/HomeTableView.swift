//
//  EmployeesTableView.swift
//  Internship
//
//  Created by sys-246 on 2/14/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

class HomeTableView: UITableView {
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
    
    rowHeight = HomeViewController.defaultRowHeight
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func set(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
    self.dataSource = dataSource
    self.delegate = delegate
  }
  
  func register(cell: (String, AnyClass), header: (String, AnyClass)) {
    register(cell.1, forCellReuseIdentifier: cell.0)
    register(header.1, forHeaderFooterViewReuseIdentifier: header.0)
  }
}
