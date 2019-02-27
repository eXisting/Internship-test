//
//  HomeViewDelegates.swift
//  Internship
//
//  Created by sys-246 on 2/22/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

protocol TableViewContaining {
  var tableView: HomeTableView { get }
  var cellId: String { get }
  var headerId: String { get }
  
  func register(cell: (AnyClass, String), header: (AnyClass, String))
  func presentController(with chosenCell: EmployeeCell)
}

extension HomeViewController: TableViewContaining {
  func presentController(with chosenCell: EmployeeCell) {
    let controller = EmployeeProfileController()
    controller.view.backgroundColor = view.backgroundColor
    controller.profile = chosenCell.employee
    
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  func register(cell: (AnyClass, String), header: (AnyClass, String)) {
    tableView.register(header.0, forHeaderFooterViewReuseIdentifier: header.1)
    tableView.register(cell.0, forCellReuseIdentifier: cell.1)
  }
  
  var cellId: String {
    return "EmployeeCell"
  }
  
  var headerId: String {
    return "ReusableHeader"
  }
  
  var tableView: HomeTableView {
    guard let homeView = view as? HomeTableView else {
      view = HomeTableView(frame: self.view.frame, style: .plain)
      return view as! HomeTableView
    }
    
    return homeView
  }
}
