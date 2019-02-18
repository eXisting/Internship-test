//
//  DepartmentTableView.swift
//  Internship
//
//  Created by sys-246 on 2/18/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit
import CoreData

class DepartmentTableViewController: UITableViewController {
  var onCellSelect: ((NSManagedObject) -> Void)?
  
  private var titleName = "Departments"
  private var cellId = "DepartmentCell"
  
  lazy var fetchController = DataBaseManager.shared.departmentsFetchController()
  
  override func loadView() {
    super.loadView()
    self.navigationItem.title = titleName
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(GeneralCell.self, forCellReuseIdentifier: cellId)
    DataBaseManager.shared.departmentsFcrDelegate = self
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let fetched = fetchController.fetchedObjects
    
    return fetched?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! GeneralCell
    
    let department = fetchController.object(at: indexPath)
    cell.name?.text = department.name
    cell.content = department
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let chosenCell = tableView.cellForRow(at: indexPath) as? GeneralCell else {
      return
    }
    
    onCellSelect?(chosenCell.content)
    self.navigationController?.popViewController(animated: true)
  }
}

extension DepartmentTableViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
    print("Will change content")
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
    print("Did change content")
  }
}
