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
  
  private var chosenDepartments: [NSManagedObject] = []
  
  lazy var fetchController = DataBaseManager.shared.departmentsFetchController()
  
  override func loadView() {
    super.loadView()
    fetchController.delegate = self
    tableView.allowsMultipleSelection = true
    tableView.allowsMultipleSelectionDuringEditing = true
    
    self.navigationItem.title = titleName
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(GeneralCell.self, forCellReuseIdentifier: cellId)
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
    
    chosenCell.setSelected(true, animated: true)
    if !chosenDepartments.contains(chosenCell.content) {
      chosenDepartments.append(chosenCell.content)
    }
  }
  
  @objc func done() {
    onCellSelect?(chosenDepartments)
    
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
