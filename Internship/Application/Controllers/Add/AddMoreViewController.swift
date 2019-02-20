//
//  AddMoreViewController.swift
//  inern
//
//  Created by Andrey Popazov on 2/12/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit
import CoreData

class AddMoreViewController: UIViewController {
  private(set) var mainView: AddEntityView!
  
  private let titleName = "Add more"
  lazy var imagePicker = ImagePicker()
  
  var callback: (() -> Void)!
  
  override func loadView() {
    super.loadView()
    
    mainView = AddEntityView(frame: self.view.frame)
    self.view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.mainView.departmentManager!.delegate = self
    self.mainView.employeeProfileView?.department!.delegate = self
    self.mainView.employeeProfileView?.role?.delegate = self
    
    self.title = titleName
    addTargets()
  }
  
  private func addTargets() {
    mainView.departmentManager?.addTarget(self, action: #selector(selectManager), for: .touchDown)
    mainView.employeeProfileView?.department?.addTarget(self, action: #selector(selectDepartment), for: .touchDown)
    mainView.employeeProfileView?.role?.addTarget(self, action: #selector(selectRole), for: .touchDown)

    let singleTap = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
    mainView.employeeProfileView?.addGestureRecognizer(singleTap)
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(save))
  }
  
  // MARK: - Objc methods
  
  @objc func save() {
// Uncomment if need to start from scratch
//    DataBaseManager.shared.createRole("Manager")
//    DataBaseManager.shared.createRole("Programmer")
//    DataBaseManager.shared.createRole("Analytics")
//    DataBaseManager.shared.createRole("ML")
//    DataBaseManager.shared.createRole("Game dev")
//    DataBaseManager.shared.createDepartment(from: ["name": "PM"])
//    DataBaseManager.shared.createDepartment(from: ["name": "Java"])
//    DataBaseManager.shared.createDepartment(from: ["name": "C++"])
//    DataBaseManager.shared.createDepartment(from: ["name": "iOS"])
//    DataBaseManager.shared.createDepartment(from: ["name": "Unity"])
    
    let data = mainView.getFieldsDataAsDict()
    if data.count != 0 {
      if mainView.segmentControll?.selectedSegmentIndex == SelectStates.deparment.rawValue {
        DataBaseManager.shared.createDepartment(from: data)
      } else {
        DataBaseManager.shared.createEmployee(from: data)
      }
      
      callback()
      self.navigationController?.popViewController(animated: true)
    }
  }
  
  @objc func selectManager() {
    let controller = ManagerTableViewController()
    controller.onCellSelect = onSelectManager
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  @objc func selectDepartment() {
    let controller = DepartmentTableViewController()
    controller.onCellSelect = onSelectDepartment
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  @objc func selectRole() {
    let controller = RoleTableViewController()
    controller.onCellSelect = onSelectRole
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  @objc func toggleState() {
    mainView.toggleVisibleStack()
  }

  @objc func chooseImage() {
    let galleryAction = UIAlertAction(title: "Gallery", style: .default, handler: { [weak self] _ in
      self?.imagePicker.openGallary()
    })

    AlertController.showChoose(for: self, title: "Choose image", galleryAction)
    
    imagePicker.setupPicker(delegate: self)
  }
  
  // MARK: Presented views callbacks
  
  private func onSelectDepartment(_ departments: [NSManagedObject]) {
    self.mainView.employeeProfileView?.departments = (departments as! [Department])
  }
  
  private func onSelectRole(_ role: NSManagedObject) {
    let role = (role as! Role)
    
    mainView.employeeProfileView?.role?.text = role.name
    mainView.employeeProfileView?.roleId = role.objectID
  }
  
  private func onSelectManager(_ managers: [NSManagedObject]) {
    mainView.managers = (managers as! [Employee])
  }
}
