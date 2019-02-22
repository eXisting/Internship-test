//
//  MainTableViewController.swift
//  inern
//
//  Created by Andrey Popazov on 2/11/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
  
  private var titleName = "Home"
  
  var tableViewController: HomeDataSource!
  
  override func loadView() {
    super.loadView()
    
    tableViewController = HomeDataSource(master: self)
    DataBaseManager.shared.resultController.delegate = self
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddMoreButtonClick))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    self.navigationItem.title = titleName
  
    tableView.set(delegate: tableViewController, dataSource: tableViewController)
    tableView.register(cell: (cellId, EmployeeCell.self), header: (headerId, ReusableHeader.self))
    
    if let departments = DataBaseManager.shared.resultController.fetchedObjects {
      for department in departments {
        tableViewController.data.append(.init(department))
      }
    }
  }
  
  @objc func onAddMoreButtonClick() {
    let controller = AddMoreViewController()
    controller.view.backgroundColor = .white
    self.navigationController?.pushViewController(controller, animated: true)
  }
}
