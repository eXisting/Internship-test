//
//  EmployeeProfileController.swift
//  inern
//
//  Created by Andrey Popazov on 2/11/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit
import CoreData

class EmployeeProfileController: UIViewController {
  private(set) var mainView: EmployeeProfile!
  
  private let titleName = "Profile"
  
  lazy var imagePicker = ImagePicker()
    
  weak var profile: Employee? {
    didSet {
      mainView.setupFields(from: profile)
    }
  }
  
  override func loadView() {
    super.loadView()
    
    mainView = EmployeeProfile(frame: CGRect(origin: CGPoint(x: 0, y: self.view.frame.height * 0.1), size: self.view.frame.size))
    self.view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mainView.department!.delegate = self
    mainView.role?.delegate = self
    mainView.location?.delegate = self
    mainView.canPickDepartment = false
    
    self.tabBarItem.title = titleName
    addTargets()
  }
  
  private func addTargets() {
    let singleTap = UITapGestureRecognizer(target: self, action: #selector(pickImage))
    mainView.profileImage?.isUserInteractionEnabled = true
    mainView.profileImage?.addGestureRecognizer(singleTap)
    
    mainView.role?.addTarget(self, action: #selector(selectRole), for: .touchDown)
    mainView.department?.addTarget(self, action: #selector(selectDepartment), for: .touchDown)
    mainView.location?.addTarget(self, action: #selector(selectLocation), for: .touchDown)
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
  }
  
  // MARK: @objc methods
  
  @objc func save() {
    guard var data = mainView.getFieldsDataAsDict() else {
      AlertController.showConfirm(for: self, "Error", "Wrong data has been passed!", .alert, {_ in })
      return
    }
    
    data["objectId"] = profile?.objectID    
    DataBaseManager.shared.update(with: data)
    
    AlertController.showConfirm(for: self, "Success", "Saved successfuly!", .alert) {
      [weak self] _ in
      self?.navigationController?.popViewController(animated: true)
    }
  }
  
  @objc func selectDepartment() {
    let controller = DepartmentTableViewController()
    controller.onCellSelect = onSelectDepartment
    controller.employeeRoleType = mainView.roleType
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  @objc func selectRole() {
    let controller = RoleTableViewController()
    controller.onCellSelect = onSelectRole
    
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  @objc func selectLocation() {
    let controller = LocationPickerController()
    controller.onSelect = onSelectLocation
    
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  @objc func pickImage() {
    let galleryAction = UIAlertAction(title: "Gallery", style: .default, handler: {
      [weak self] _ in
      self?.imagePicker.openGallary()
    })
    
    AlertController.showChoose(for: self, title: "Choose image", galleryAction)
    
    imagePicker.setupPicker(delegate: self)
  }
  
  // MARK: Presented views callbacks
  
  private func onSelectDepartment(_ departments: [NSManagedObject]) {
    mainView.departments = (departments as! [Department])
  }
  
  private func onSelectRole(_ role: NSManagedObject) {
    let role = (role as! Role)
    
    mainView.role?.text = role.name
    mainView.roleId = role.objectID
    
    if mainView.roleType != .manager {
      mainView.clearDepartments()
    }
    
    mainView.canPickDepartment = true
  }
  
  private func onSelectLocation(_ object: AnyObject) {
    
  }
}
