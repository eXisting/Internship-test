//
//  MainTableViewController.swift
//  inern
//
//  Created by Andrey Popazov on 2/11/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
  
  static let defaultRowHeight = UIScreen.main.bounds.height * 0.08

  private var titleName = "Employees"
  private var cellId = "EmployeeCell"
  private var rowsCount = 20
  
  override func loadView() {
    super.loadView()
    tableView.rowHeight = MainTableViewController.defaultRowHeight
    self.navigationItem.title = titleName
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddMoreButtonClick))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(EmployeeCell.self, forCellReuseIdentifier: cellId)
  }
  
  @objc func onAddMoreButtonClick() {
    let controller = AddMoreViewController()
    controller.view.backgroundColor = .white
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rowsCount
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let chosenCell = tableView.cellForRow(at: indexPath) as? EmployeeCell else {
      return
    }
    
    let controller = EmployeeProfileController()
    controller.view.backgroundColor = self.view.backgroundColor
    controller.profile = chosenCell.employee
    self.navigationController?.pushViewController(controller, animated: true)
  }
}
