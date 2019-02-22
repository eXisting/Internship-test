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
  var onCellSelect: (([NSManagedObject]) -> Void)?
  
  private var titleName = "Employees"
  private var cellId = "SelectableEmployeeCell"
  
  private var chosenManagers: [NSManagedObject] = []
  
  //lazy var fetchController = DataBaseManager.shared.managerFetchController()
  
  override func loadView() {
    super.loadView()
    
    tableView.rowHeight = GeneralCell.defaultRowHeight
    tableView.allowsMultipleSelection = true
    tableView.allowsMultipleSelectionDuringEditing = true
    
    self.navigationItem.title = titleName
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(SelectableEmployeeCell.self, forCellReuseIdentifier: cellId)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let fetched = DataBaseManager.shared.getManagers().count//fetchController.fetchedObjects
    
    return fetched//fetched?.count ?? 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EmployeeCell
    
    let employee = DataBaseManager.shared.getManagers()[indexPath.row] //fetchController.object(at: indexPath)
    cell.employee = employee
    cell.populateTextFields()
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let chosenCell = tableView.cellForRow(at: indexPath) as? EmployeeCell else {
      return
    }
    
    chosenCell.setSelected(true, animated: true)
    if !chosenManagers.contains(chosenCell.employee) {
      chosenManagers.append(chosenCell.employee)      
    }
  }
  
  @objc func done() {
    onCellSelect?(chosenManagers)
    
    self.navigationController?.popViewController(animated: true)
  }
}

extension ManagerTableViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    switch type {
    case .insert:
      tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
    case .delete:
      tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
    case .move:
      break
    case .update:
      break
    }
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      tableView.insertRows(at: [newIndexPath!], with: .fade)
    case .delete:
      tableView.deleteRows(at: [indexPath!], with: .fade)
    case .update:
      tableView.reloadRows(at: [indexPath!], with: .fade)
    case .move:
      tableView.moveRow(at: indexPath!, to: newIndexPath!)
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
}
