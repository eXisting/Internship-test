//
//  HomeTableViewDelegates.swift
//  Internship
//
//  Created by sys-246 on 2/19/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit
import CoreData

class HomeDataSource: NSObject {
  var data: [SectionData] = []
  
  var master: TableViewContaining!
  
  init(master: TableViewContaining) {
    super.init()
    
    self.master = master
  }
}

extension HomeDataSource: ExandableHeaderViewDelegate {
  func toogleExpand(for header: ReusableHeader, section: Int) {
    data[section].isCollapsed = !data[section].isCollapsed
    
    header.data.isCollapsed = data[section].isCollapsed
    
    master.tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .fade)
  }
}

extension HomeDataSource: DeletableHeaderDelegate {
  func deleteSection(section: Int) {
    DataBaseManager.shared.delete(departmentId: data[section].department.objectID)
    
    data.remove(at: section)
    
    master.tableView.deleteSections(NSIndexSet(index: section) as IndexSet, with: .fade)
  }
}

extension HomeDataSource: UITableViewDataSource {
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
    return ReusableHeader.defaultSectionHeight
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = master.tableView.dequeueReusableCell(withIdentifier: master.cellId, for: indexPath) as! EmployeeCell
    
    let object = data[indexPath.section]
    cell.employee = object.employees[indexPath.row]
    cell.populateTextFields()
    
    return cell
  }
}

extension HomeDataSource: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = master.tableView.dequeueReusableHeaderFooterView(withIdentifier: master.headerId) as! ReusableHeader
    data[section].section = section
    header.data = data[section]
    header.collapseDelegate = self
    header.deleteDelegate = self
    
    header.setupDelButton(ReusableHeader.defaultSectionHeight, tableView.frame.width * 0.9)
    
    return header
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let chosenCell = master.tableView.cellForRow(at: indexPath) as? EmployeeCell else {
      return
    }
    
    master.presentController(with: chosenCell)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if (editingStyle == .delete) {
      DataBaseManager.shared.delete(
        employeeId: data[indexPath.section].employees[indexPath.row].objectID,
        fromDepartment: data[indexPath.section].department.objectID
      )
      
      data[indexPath.section].employees.remove(at: indexPath.row)
      
      master.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
}
