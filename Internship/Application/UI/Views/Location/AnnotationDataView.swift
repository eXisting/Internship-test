//
//  AnnotationDataView.swift
//  Internship
//
//  Created by sys-246 on 2/27/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

class AnnotationDataView: UIView {
  weak var employee: Employee? {
    didSet {
      name.text = employee?.name
      phone.text = employee?.phone
    }
  }
  
  var stackView = UIStackView()
  
  var name = UILabel()
  var phone = UILabel()
  
  var findPath = UIButton()
  
  func laidOutViews() {
    backgroundColor = .white
    name.textAlignment = .center
    phone.textAlignment = .center
    findPath.setTitle("Find path", for: .normal)
    findPath.backgroundColor = .blue
    
    addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.axis = .vertical
    
    NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: stackView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: stackView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0).isActive = true
    
    stackView.addArrangedSubview(name)
    stackView.addArrangedSubview(phone)
    stackView.addArrangedSubview(findPath)
  }
}
