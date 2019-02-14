//
//  MainTableViewController.swift
//  inern
//
//  Created by Andrey Popazov on 2/11/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

class EmployeesViewController: UIViewController {
  
  static let defaultRowHeight = UIScreen.main.bounds.height * 0.08
  static let defaultSectionHeight = UIScreen.main.bounds.height * 0.1

  private var titleName = "Employees"
  
  private var cellId = "EmployeeCell"
  private var headerId = "ReusableHeader"
  
  var dataSource: EmployeesDataSource!
  var tableView: EmployeesTableView!
  
  override func loadView() {
    super.loadView()
    
    tableView = EmployeesTableView(frame: self.view.frame, style: .plain)
    dataSource = EmployeesDataSource()
    
    self.view = tableView
    
    tableView?.set(delegate: self, dataSource: self)

    self.navigationItem.title = titleName
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddMoreButtonClick))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(cell: (cellId, EmployeeCell.self), header: (headerId, ReusableHeader.self))
  }
  
  @objc func onAddMoreButtonClick() {
    let controller = AddMoreViewController()
    controller.view.backgroundColor = .white
    self.navigationController?.pushViewController(controller, animated: true)
  }
}

extension EmployeesViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return dataSource.sections.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.sections[section].count
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return EmployeesViewController.defaultSectionHeight
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EmployeeCell

    cell.name?.text = "John \(indexPath.row)"
    cell.role?.text = "Some Role"
    let url = URL(string: "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png")
    let data = try? Data(contentsOf: url!)

    if let imageData = data {
      cell.photo?.image = UIImage(data: imageData)
    }

    return cell
  }
}

extension EmployeesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Section \(section)"
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
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if (editingStyle == .delete) {
      dataSource.sections[indexPath.section].remove(at: indexPath.row)
      self.tableView!.deleteRows(at: [indexPath], with: .automatic)
    }
  }
}
