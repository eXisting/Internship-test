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
  
  static let defaultRowHeight = UIScreen.main.bounds.height * 0.08
  static let defaultSectionHeight = UIScreen.main.bounds.height * 0.1

  private var titleName = "Home"
  
  private var cellId = "EmployeeCell"
  private var headerId = "ReusableHeader"
  
  var tableView: EmployeesTableView!
  lazy var fetchController = DataBaseManager.shared.employeesFetchController()
  
  var data: [[Employee]] = []
  
  override func loadView() {
    super.loadView()
    
    tableView = EmployeesTableView(frame: self.view.frame, style: .plain)
    
    self.view = tableView
    
    tableView?.set(delegate: self, dataSource: self)

    self.navigationItem.title = titleName
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddMoreButtonClick))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(cell: (cellId, EmployeeCell.self), header: (headerId, ReusableHeader.self))
    
    data.append(fetchController.fetchedObjects ?? [])
  }
  
  @objc func onAddMoreButtonClick() {
    let controller = AddMoreViewController()
    controller.view.backgroundColor = .white
    self.navigationController?.pushViewController(controller, animated: true)
  }
}

extension HomeViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data[section].count
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return HomeViewController.defaultSectionHeight
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EmployeeCell

    let object = data[indexPath.section][indexPath.row]
    cell.employee = object
    cell.populateTextFields()
    
    return cell
  }
}

extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return ""
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! ReusableHeader
    header.textLabel?.text = "Section \(section)"
    
    return header
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let chosenCell = tableView.cellForRow(at: indexPath) as? EmployeeCell else {
      return
    }

    let controller = EmployeeProfileController()
    controller.view.backgroundColor = self.view.backgroundColor
    controller.profile = chosenCell.employee
    controller.indexPath = indexPath
    
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if (editingStyle == .delete) {
      DataBaseManager.shared.delete(id: data[indexPath.section][indexPath.row].objectID)
      
      data[indexPath.section].remove(at: indexPath.row)
      
      self.tableView!.deleteRows(at: [indexPath], with: .automatic)
    }
  }
}

extension HomeViewController: NSFetchedResultsControllerDelegate {
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
