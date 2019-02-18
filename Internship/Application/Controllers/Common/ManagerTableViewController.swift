//
//  ManagerTableViewController.swift
//  Internship
//
//  Created by sys-246 on 2/14/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit
import CoreData

class ManagerTableViewController: UITableViewController {
  var onCellSelect: ((NSManagedObject) -> Void)?
  
  private var titleName = "Employees"
  private var cellId = "EmployeeCell"
  
  lazy var fetchController = DataBaseManager.shared.employeesFetchController()
  
  override func loadView() {
    super.loadView()
    tableView.rowHeight = EmployeesViewController.defaultRowHeight
    self.navigationItem.title = titleName
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(EmployeeCell.self, forCellReuseIdentifier: cellId)
    DataBaseManager.shared.employeesFcrDelegate = self
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let fetched = fetchController.fetchedObjects
    
    return fetched?.count ?? 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EmployeeCell
    
    let employee = fetchController.object(at: indexPath)
    cell.employee = employee
    cell.populateTextFields()
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let chosenCell = tableView.cellForRow(at: indexPath) as? EmployeeCell else {
      return
    }
    
    onCellSelect?(chosenCell.employee)
    self.navigationController?.popViewController(animated: true)
  }
}

extension ManagerTableViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
    print("Will change content")
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
    print("Did change content")
  }
}
