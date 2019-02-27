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
  
  private let titleName = "Add"
  lazy var imagePicker = ImagePicker()
  
  override func loadView() {
    super.loadView()
    
    mainView = AddEntityView(frame: self.view.frame)
    self.view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mainView.departmentManager!.delegate = self
    mainView.employeeProfileView?.department!.delegate = self
    mainView.employeeProfileView?.role?.delegate = self
    mainView.employeeProfileView?.canPickDepartment = false
    
    self.title = titleName
    addTargets()
  }
  
  private func addTargets() {
    mainView.departmentManager?.addTarget(self, action: #selector(selectManager), for: .touchDown)
    mainView.employeeProfileView?.department?.addTarget(self, action: #selector(selectDepartment), for: .touchDown)
    mainView.employeeProfileView?.role?.addTarget(self, action: #selector(selectRole), for: .touchDown)
    mainView.employeeProfileView?.location?.addTarget(self, action: #selector(selectLocation), for: .touchDown)

    let singleTap = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
    mainView.employeeProfileView?.profileImage?.isUserInteractionEnabled = true
    mainView.employeeProfileView?.profileImage?.addGestureRecognizer(singleTap)
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(save))
  }
  
  // MARK: - Objc methods
  
  @objc func save() {
// Uncomment if need to start from scratch
//    DataBaseManager.shared.createRole("PM")
//    DataBaseManager.shared.createRole("Programmer")
//    DataBaseManager.shared.createRole("Analytics")
//    DataBaseManager.shared.createRole("ML")
//    DataBaseManager.shared.createRole("Game dev")
//    DataBaseManager.shared.createDepartment(from: ["name": "PM"])
//    DataBaseManager.shared.createDepartment(from: ["name": "Java"])
//    DataBaseManager.shared.createDepartment(from: ["name": "C++"])
//    DataBaseManager.shared.createDepartment(from: ["name": "iOS"])
//    DataBaseManager.shared.createDepartment(from: ["name": "Unity"])
    
    guard let data = mainView.getFieldsDataAsDict() else {
      AlertController.showConfirm(for: self, "Error", "Wrong data has been passed!", .alert, {_ in })
      return
    }

    if mainView.segmentControll?.selectedSegmentIndex == SelectStates.deparment.rawValue {
      DataBaseManager.shared.createDepartment(from: data)
    } else {
      DataBaseManager.shared.createEmployee(from: data)
    }

    self.navigationController?.popViewController(animated: true)
  }
  
  @objc func selectManager() {
    let controller = ManagerTableViewController()
    controller.onCellSelect = onSelectManager
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  @objc func selectDepartment() {
    let controller = DepartmentTableViewController()
    controller.onCellSelect = onSelectDepartment
    controller.employeeRoleType = mainView.employeeProfileView?.roleType
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
  
  @objc func selectLocation() {
    let controller = LocationPickerController()
    controller.onSelect = onSelectLocation
    
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  // MARK: Presented views callbacks
  
  private func onSelectDepartment(_ departments: [NSManagedObject]) {
    self.mainView.employeeProfileView?.departments = (departments as! [Department])
  }
  
  private func onSelectRole(_ role: NSManagedObject) {
    let role = (role as! Role)
    
    mainView.employeeProfileView?.role?.text = role.name
    mainView.employeeProfileView?.roleId = role.objectID
    
    if mainView.employeeProfileView?.roleType != .manager {
      mainView.employeeProfileView?.clearDepartments()
    }
    
    mainView.employeeProfileView?.roleType = role.name == RoleType.manager.rawValue ? .manager : .regular
    mainView.employeeProfileView?.canPickDepartment = true
  }
  
  private func onSelectManager(_ managers: [NSManagedObject]) {
    mainView.managers = (managers as! [Employee])
  }
  
  private func onSelectLocation(_ object: AnyObject) {
    
  }
}
