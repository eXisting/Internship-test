//
//  EmployeeProfile.swift
//  inern
//
//  Created by Andrey Popazov on 2/11/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit
import CoreData

enum RoleType: String {
  case manager = "PM"
  case regular
}

class EmployeeProfile: UIView {
  var profileImage: UIImageView?
  
  var name: UITextField?
  var role: UITextField?
  var phone: UITextField?
  var email: UITextField?
  var department: UITextField?
  
  var tableView: UITableView?
  
  var departments: [Department]? {
    didSet {
      var names = ""
      
      for element in departments! {
        names += " \(element.name ?? "");"
      }
      
      department?.text = names
    }
  }
  
  var canPickDepartment: Bool! {
    didSet {
      department!.isUserInteractionEnabled = canPickDepartment
    }
  }
  
  var roleId: NSManagedObjectID?
  var roleType: RoleType!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    instantiateViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupFields(from employee: Employee?) {
    name?.text = employee?.name
    role?.text = employee?.role?.name
    phone?.text = employee?.phone
    email?.text = employee?.email
    
    departments = (employee?.department?.allObjects as! [Department])
    
    profileImage?.image = UIImage(data: employee?.photo ?? Data())
    
    roleId = employee?.role?.objectID
    
    canPickDepartment = roleId != nil
    roleType = role?.text != RoleType.manager.rawValue ? .regular : .manager
  }
  
  func clearDepartments() {
    departments = []
    department?.text = ""
  }
  
  func getFieldsDataAsDict() -> [String: Any]? {    
    guard let userName = name?.text,
      let phoneValue = phone?.text,
      let emailValue = email?.text,
      let roleValue = roleId,
      let depIds = departments,
      let photoValue = profileImage?.image?.pngData() else {
      return nil
    }
    
    var ids: [Any] = []
    for element in depIds {
      ids.append(element.objectID)
    }
    
    return [
      "name": userName as Any,
      "phone": phoneValue as Any,
      "email": emailValue as Any,
      "roleId": roleValue as Any,
      "departmentsIds": ids,
      "photo": photoValue as Any
    ]
  }
  
  func laidOutViews() {
    setupImage()
    laidOutTableView()
  }
  
  private func instantiateViews() {
    tableView = UITableView()
    name = UITextField()
    role = UITextField()
    phone = UITextField()
    email = UITextField()
    department = UITextField()
    profileImage = UIImageView()
    
    addSubview(profileImage!)
    addSubview(tableView!)
  }
  
  private func laidOutTableView() {
    tableView!.addConstraint(
      NSLayoutConstraint(
        item: tableView!,
        attribute: .bottom,
        relatedBy: .equal,
        toItem: self,
        attribute: .bottom,
        multiplier: 1,
        constant: 0)
    )
    
    tableView!.addConstraint(
      NSLayoutConstraint(
        item: tableView!,
        attribute: .left,
        relatedBy: .equal,
        toItem: self,
        attribute: .left,
        multiplier: 0.9,
        constant: 0)
    )
    
    tableView!.addConstraint(
      NSLayoutConstraint(
        item: tableView!,
        attribute: .right,
        relatedBy: .equal,
        toItem: self,
        attribute: .right,
        multiplier: 0.9,
        constant: 0)
    )
    
    tableView!.addConstraint(
      NSLayoutConstraint(
        item: tableView!,
        attribute: .top,
        relatedBy: .equal,
        toItem: self,
        attribute: .top,
        multiplier: 0.4,
        constant: 0)
    )

    setupTextFields()
  }
  
  private func setupTextFields() {
    name!.textColor = .black
    name!.font = UIFont.boldSystemFont(ofSize: 17)
    name!.clearButtonMode = .whileEditing
    name!.textAlignment = .left
    name!.placeholder = "Name"
    
    role!.textColor = .black
    role!.font = UIFont.boldSystemFont(ofSize: 17)
    role!.clearButtonMode = .whileEditing
    role!.textAlignment = .left
    role!.placeholder = "Position"
    
    phone!.textColor = .black
    phone!.font = UIFont.boldSystemFont(ofSize: 17)
    phone!.clearButtonMode = .whileEditing
    phone!.textAlignment = .left
    phone!.placeholder = "Phone"
    
    email!.textColor = .black
    email!.font = UIFont.boldSystemFont(ofSize: 17)
    email!.clearButtonMode = .whileEditing
    email!.textAlignment = .left
    email!.placeholder = "E-mail"
    
    department!.textColor = .black
    department!.font = UIFont.boldSystemFont(ofSize: 17)
    department!.clearButtonMode = .whileEditing
    department!.textAlignment = .left
    department!.placeholder = "Department"

    //tableView?.insertSubview(name!, at: 0)
//    tableView!.addArrangedSubview(name!)
//    tableView!.addArrangedSubview(role!)
//    tableView!.addArrangedSubview(phone!)
//    tableView!.addArrangedSubview(email!)
//    tableView!.addArrangedSubview(department!)
  }
  
  private func setupImage() {
//    let size = self.frame.width * 0.4
//    let imageSize = CGSize(width: size, height: size)
//    let orign = CGPoint(x: self.frame.width / 2 - size / 2, y: size / 2)
//    
//    profileImage?.frame = CGRect(origin: orign, size: imageSize)
//    profileImage?.backgroundColor = .lightGray
  }
}
