//
//  ManagerTableViewController.swift
//  Internship
//
//  Created by sys-246 on 2/14/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

class ManagerTableViewController: UITableViewController {
  var onCellSelect: ((String) -> Void)?
  
  private var titleName = "Employees"
  private var cellId = "EmployeeCell"
  private var rowsCount = 20
  
  override func loadView() {
    super.loadView()
    tableView.rowHeight = MainTableViewController.defaultRowHeight
    self.navigationItem.title = titleName
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(EmployeeCell.self, forCellReuseIdentifier: cellId)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rowsCount
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EmployeeCell
    
    // TODO: Load all managers from core data
    
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
    
    onCellSelect?(chosenCell.name!.text!)
    self.navigationController?.popViewController(animated: true)
  }
}
