//
//  EmployeeProfile.swift
//  inern
//
//  Created by Andrey Popazov on 2/11/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

class EmployeeProfile: UIView {
  private var profileImage: UIImageView?
  
  private var infoStack: UIStackView?
  
  private var name: UITextField?
  private var role: UITextField?
  private var phone: UITextField?
  private var email: UITextField?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    laidOutViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func laidOutViews() {
    laidOutImage()
    laidOutInfoStack()
    laidOutTextFields()
  }
  
  private func laidOutInfoStack() {
    let stackSize = CGSize(width: self.frame.width * 0.65, height: self.frame.height * 0.3)
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
    
    infoStack!.addArrangedSubview(name!)
    infoStack!.addArrangedSubview(role!)
    infoStack!.addArrangedSubview(phone!)
    infoStack!.addArrangedSubview(email!)
    
    name?.text = "Hello"
    role?.text = "TRainee"
    phone?.text = "812392918239"
    email?.text = "something@gmail.com"
  }
  
  private func laidOutImage() {
    let size = self.frame.width * 0.25
    let imageSize = CGSize(width: size, height: size)
    let orign = CGPoint(x: self.frame.width / 2 - size / 2, y: size / 2)
    
    profileImage = UIImageView(frame: CGRect(origin: orign, size: imageSize))
    addSubview(profileImage!)
  }
}
