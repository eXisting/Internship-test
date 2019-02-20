//
//  HomeTableViewDelegates.swift
//  Internship
//
//  Created by sys-246 on 2/19/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit
import CoreData

class HomeTableViewDelegates: NSObject {
  let cellId = "EmployeeCell"
  let headerId = "ReusableHeader"
  
  lazy var fetchController = DataBaseManager.shared.departmentsFetchController()
  
  var tableView: HomeTableView!
  var data: [SectionData] = []
  
  var rootController: HomeViewController!
  
  init(rootController: HomeViewController, tableView: HomeTableView) {
    super.init()
    
    self.rootController = rootController
    self.tableView = tableView
    
    self.tableView.set(delegate: self, dataSource: self)
    self.fetchController.delegate = self
  }
}

extension HomeTableViewDelegates: ExandableHeaderViewDelegate {
  func toogleExpand(for header: ReusableHeader, section: Int) {
    data[section].isCollapsed = !data[section].isCollapsed
    
    header.data.isCollapsed = data[section].isCollapsed
    
    tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .fade)
  }
}

extension HomeTableViewDelegates: DeletableHeaderDelegate {
  func deleteSection(section: Int) {
    DataBaseManager.shared.delete(departmentId: data[section].department.objectID)
    
    data.remove(at: section)
    
    tableView.deleteSections(NSIndexSet(index: section) as IndexSet, with: .fade)
  }
}

extension HomeTableViewDelegates: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if data[section].isCollapsed {
      return 0
    }
    
    return data[section].employees.count
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return HomeViewController.defaultSectionHeight
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EmployeeCell
    
    let object = data[indexPath.section]
    cell.employee = object.employees[indexPath.row]
    cell.populateTextFields()
    
    return cell
  }
}

extension HomeTableViewDelegates: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! ReusableHeader
    data[section].section = section
    header.data = data[section]
    header.collapseDelegate = self
    header.deleteDelegate = self
    
    header.setupDelButton(HomeViewController.defaultSectionHeight, tableView.frame.width * 0.85)
    
    return header
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let chosenCell = tableView.cellForRow(at: indexPath) as? EmployeeCell else {
      return
    }
    
    let controller = EmployeeProfileController()
    controller.view.backgroundColor = rootController.view.backgroundColor
    controller.profile = chosenCell.employee
    
    rootController.navigationController?.pushViewController(controller, animated: true)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if (editingStyle == .delete) {
      DataBaseManager.shared.delete(
        employeeId: data[indexPath.section].employees[indexPath.row].objectID,
        fromDepartment: data[indexPath.section].department.objectID
      )
      
      data[indexPath.section].employees.remove(at: indexPath.row)
      
      self.tableView!.deleteRows(at: [indexPath], with: .automatic)
    }
  }
}

extension HomeTableViewDelegates: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
    print("tableView.beginUpdates()")
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
    print("tableView.endUpdates()")
  }
}
