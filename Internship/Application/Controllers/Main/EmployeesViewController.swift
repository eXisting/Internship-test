//
//  MainTableViewController.swift
//  inern
//
//  Created by Andrey Popazov on 2/11/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit
import CoreData

class EmployeesViewController: UIViewController {
  
  static let defaultRowHeight = UIScreen.main.bounds.height * 0.08
  static let defaultSectionHeight = UIScreen.main.bounds.height * 0.1

  private var titleName = "Home"
  
  private var cellId = "EmployeeCell"
  private var headerId = "ReusableHeader"
  
  var tableView: EmployeesTableView!
  lazy var fetch = DataBaseManager.shared.employeesFetchController()
  
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
    
    DataBaseManager.shared.employeesFcrDelegate = self
  }
  
  @objc func onAddMoreButtonClick() {
    let controller = AddMoreViewController()
    controller.view.backgroundColor = .white
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  func refreshRowsAtPath(path: IndexPath?) {
    tableView.beginUpdates()
    tableView.reloadRows(at: [path!], with: .automatic)
    tableView.endUpdates()
  }
}

extension EmployeesViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return fetch.sections!.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sections = fetch.sections else {
      fatalError("No sections in fetchedResultsController")
    }
    let sectionInfo = sections[section]
    return sectionInfo.numberOfObjects
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return EmployeesViewController.defaultSectionHeight
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EmployeeCell

    let object = fetch.object(at: indexPath)
    cell.employee = object
    cell.populateTextFields()
    
    return cell
  }
}

extension EmployeesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard let sectionInfo = fetch.sections?[section] else {
      return nil
    }
    
    return sectionInfo.name
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
      DataBaseManager.shared.delete(object: fetch.object(at: indexPath))
      self.tableView!.deleteRows(at: [indexPath], with: .automatic)
    }
  }
}

extension EmployeesViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
    print("Will change content")
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
    print("Did change content")
  }
}
