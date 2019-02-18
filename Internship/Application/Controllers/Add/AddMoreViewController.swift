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
  lazy var imagePicker = UIImagePickerController()
  
  override func loadView() {
    super.loadView()
    self.title = titleName
    
    mainView = AddEntityView(frame: self.view.frame)
    self.view = mainView
    
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
//    DataBaseManager.shared.createRole("Junior")
//    DataBaseManager.shared.createRole("Senior")
//    DataBaseManager.shared.createRole("Middle")
//    DataBaseManager.shared.createRole("Intern")
//    DataBaseManager.shared.createDepartment(from: ["name": "PM"])
//    DataBaseManager.shared.createDepartment(from: ["name": "Java"])
//    DataBaseManager.shared.createDepartment(from: ["name": "C++"])

    let data = mainView.getFieldsDataAsDict()
//    let data: [String: Any] = [
//      "name": "Johny" as Any,
//      "phone": "12418249182" as Any,
//      "email": "fjdlsf@gmail.com" as Any,
//      "role": mainView.employeeProfileView!.roleObject! as Any,
//      "department": mainView.employeeProfileView!.departmentObject! as Any,
//      "photo": ""
//    ]

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
    let cameraAction =  UIAlertAction(title: "Camera", style: .default, handler: { _ in
      self.openCamera()
    })
    
    let galleryAction = UIAlertAction(title: "Gallery", style: .default, handler: { _ in
      self.openGallary()
    })

    AlertController.showChoose(for: self, title: "Choose image", cameraAction, galleryAction)
    
    imagePicker.delegate = self
    imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
    imagePicker.allowsEditing = false
  }
  
  private func onSelectDepartment(_ department: NSManagedObject) {
    self.mainView.employeeProfileView?.departmentObject = (department as! Department)
  }
  
  private func onSelectRole(_ role: NSManagedObject) {
    let role = (role as! Role)
    
    mainView.employeeProfileView?.role?.text = role.name
    mainView.employeeProfileView?.roleId = role.objectID
  }
  
  private func onSelectManager(_ manager: NSManagedObject) {
    mainView.manager = (manager as! Employee)
  }
}
