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
  var onCellSelect: (([NSManagedObject]) -> Void)?
  
  private var titleName = "Departments"
  private var cellId = "DepartmentCell"
  
  private var chosenDepartments: [Int: NSManagedObject] = [:]
  
  var employeeRoleType: RoleType!
  
  override func loadView() {
    super.loadView()
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = titleName

    tableView.allowsMultipleSelection = true
    tableView.allowsMultipleSelectionDuringEditing = true
    
    tableView.register(SelectableGeneralCell.self, forCellReuseIdentifier: cellId)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let fetched = DataBaseManager.shared.resultController.fetchedObjects

    return fetched?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SelectableGeneralCell
    cell.setSelected(true, animated: true)
    
    let department =  DataBaseManager.shared.resultController.object(at: indexPath)
    cell.name?.text = department.name
    cell.content = department
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let chosenCell = tableView.cellForRow(at: indexPath) as? SelectableGeneralCell else {
      return
    }
    
    chosenDepartments[indexPath.row] = chosenCell.content
  }
  
  override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    chosenDepartments.removeValue(forKey: indexPath.row)
  }
  
  @objc func done() {
    if chosenDepartments.count == 0 || employeeRoleType == .regular && chosenDepartments.count > 1 {
      AlertController.showConfirm(for: self, "Error", "Invalid count of choosen departments!", .alert, {_ in })
      return
    }
    
    onCellSelect?(chosenDepartments.map{ $0.1 })
    
    self.navigationController?.popViewController(animated: true)
  }
}

extension DepartmentTableViewController: NSFetchedResultsControllerDelegate {
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
