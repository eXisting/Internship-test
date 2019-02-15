//
//  EmployeeProfileController.swift
//  inern
//
//  Created by Andrey Popazov on 2/11/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

class EmployeeProfileController: UIViewController {
  private var mainView: EmployeeProfile!
  
  private let titleName = "Profile"
  var indexPath: IndexPath?
  
  weak var profile: Employee? {
    didSet {
      mainView.setupFields(from: profile)
    }
  }
  
  override func loadView() {
    super.loadView()
    self.tabBarItem.title = titleName
    
    mainView = EmployeeProfile(frame: CGRect(origin: CGPoint(x: 0, y: self.view.frame.height * 0.1), size: self.view.frame.size))
    self.view.addSubview(mainView)
    
    
    mainView.role?.addTarget(self, action: #selector(selectRole), for: .touchDown)
    mainView.department?.addTarget(self, action: #selector(selectDepartment), for: .touchDown)
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
  }
  
  @objc func save() {
    var dict = mainView.getFieldsDataAsDict()
    dict["objectId"] = DataBaseManager.shared.getFetchController().object(at: indexPath!).objectID
    
    DataBaseManager.shared.update(with: dict)
    
    AlertController.showConfirm(for: self, "Success", "Saved successfuly!", .alert) {
      [weak self] _ in
      self!.navigationController?.popViewController(animated: true)
    }
  }
  
  @objc func selectRole() {
    
  }
  
  @objc func selectDepartment() {
    
  }
}
