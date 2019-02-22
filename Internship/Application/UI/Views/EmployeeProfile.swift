//
//  EmployeeProfile.swift
//  inern
//
//  Created by Andrey Popazov on 2/11/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit
import CoreData

class EmployeeProfile: UIView {
  var profileImage: UIImageView?
  
  var name: UITextField?
  var role: UITextField?
  var phone: UITextField?
  var email: UITextField?
  var department: UITextField?
  
  var departments: [Department]? {
    didSet {
      var names = ""
      
      for element in departments! {
        names += " \(element.name ?? "");"
      }
      
      department?.text = names
    }
  }
  
  var roleId: NSManagedObjectID?
  
  var infoStack: UIStackView?

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    laidOutViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupFields(from employee: Employee?) {
    name?.text = employee?.name
    role?.text = employee?.role?.name
    phone?.text = employee?.phone
    email?.text = employee?.email
    
    for element in (employee?.department)! {
      guard let element = element as? Department else {
        continue
      }
      
      department?.text?.append(" \(element.name ?? "");")
    }
    
    profileImage?.image = UIImage(data: employee?.photo ?? Data())
    
    roleId = employee?.role?.objectID
  }
  
  func getFieldsDataAsDict() -> [String: Any] {
    var ids: [Any] = []
    if let depIds = departments {
      for element in depIds {
        ids.append(element.objectID)
      }
    }
    
    return [
      "name": name?.text as Any,
      "phone": phone?.text as Any,
      "email": email?.text as Any,
      "roleId": roleId as Any,
      "departmentsIds": ids,
      "photo": profileImage?.image?.pngData() as Any
    ]
  }
  
  private func laidOutViews() {
    laidOutImage()
    laidOutInfoStack()
    laidOutTextFields()
  }
  
  private func laidOutInfoStack() {
    let stackSize = CGSize(width: self.frame.width * 0.65, height: self.frame.height * 0.4)
    let orign = CGPoint(x: self.frame.width / 2 - stackSize.width / 2, y: self.frame.height * 0.4)
    
    infoStack = UIStackView(frame: CGRect(origin: orign, size: stackSize))
    infoStack?.alignment = .fill
    infoStack?.distribution = .fillEqually
    infoStack?.axis = .vertical
    addSubview(infoStack!)
  }
  
  private func laidOutTextFields() {
    name = UITextField()
    role = UITextField()
    phone = UITextField()
    email = UITextField()
    department = UITextField()

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

    infoStack!.addArrangedSubview(name!)
    infoStack!.addArrangedSubview(role!)
    infoStack!.addArrangedSubview(phone!)
    infoStack!.addArrangedSubview(email!)
    infoStack!.addArrangedSubview(department!)
  }
  
  private func laidOutImage() {
    let size = self.frame.width * 0.4
    let imageSize = CGSize(width: size, height: size)
    let orign = CGPoint(x: self.frame.width / 2 - size / 2, y: size / 2)
    
    profileImage = UIImageView(frame: CGRect(origin: orign, size: imageSize))
    profileImage?.backgroundColor = .lightGray
    
    addSubview(profileImage!)
  }
}
