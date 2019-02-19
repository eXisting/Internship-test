//
//  RoleTableViewController.swift
//  Internship
//
//  Created by sys-246 on 2/18/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit
import CoreData

class RoleTableViewController: UITableViewController {
  var onCellSelect: ((NSManagedObject) -> Void)?
  
  private var titleName = "Roles"
  private var cellId = "Role"
  
  lazy var fetchController = DataBaseManager.shared.rolesFetchController()
  
  override func loadView() {
    super.loadView()
    self.navigationItem.title = titleName
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
    
    let role = fetchController.object(at: indexPath)
    cell.name?.text = role.name
    cell.content = role
    
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
