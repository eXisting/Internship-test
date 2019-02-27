//
//  AddEntityView.swift
//  Internship
//
//  Created by sys-246 on 2/14/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

enum SelectStates: Int {
  case employee = 0
  case deparment = 1
}

class AddEntityView: UIView {
  private(set) var segmentControll: UISegmentedControl?
  
  //private(set) var employeeProfileView: EmployeeProfile?
  private var departmentStackView: UIStackView?
  
  private(set) var departmentName: UITextField?
  private(set) var departmentManager: UITextField?
  
  var managers: [Employee]? {
    didSet {
      var names = ""
      
      for element in managers! {
        names += " \(element.name ?? "");"
      }
      
      departmentManager?.text = names
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    instantiateViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func getFieldsDataAsDict() -> [String: Any]? {
    return ["": "" as Any]
//    return segmentControll?.selectedSegmentIndex == SelectStates.employee.rawValue ?
//      employeeProfileView!.getFieldsDataAsDict() : getDepartmentFieldsAsDict()
  }
  
  private func getDepartmentFieldsAsDict() -> [String: Any]? {
    guard let depIds = managers,
      let depName = departmentName?.text else {
      return nil
    }
    
    var ids: [Any] = []
    for element in depIds {
      ids.append(element.objectID)
    }
    
    return [
      "name": depName as Any,
      "employeesIds": ids
    ]
  }
  
  @objc func toggleVisibleStack() {
    departmentStackView?.isHidden = !departmentStackView!.isHidden
//    employeeProfileView?.isHidden = !employeeProfileView!.isHidden
  }
  
  func laidOutViews() {
    laidOutSegment()

    setupStack()
    setUpStackFields()
    
//    employeeProfileView?.laidOutViews()
  }
  
  private func instantiateViews() {
//    employeeProfileView = EmployeeProfile(frame: self.frame)
    departmentStackView = UIStackView(frame: self.frame)
    segmentControll = UISegmentedControl(frame: self.frame)
    departmentName = UITextField()
    departmentManager = UITextField()
    
//    addSubview(employeeProfileView!)
    addSubview(departmentStackView!)
    departmentStackView!.addArrangedSubview(departmentName!)
    departmentStackView!.addArrangedSubview(departmentManager!)
  }
  
  private func setupStack() {
    NSLayoutConstraint(
      item: departmentStackView!,
      attribute: .height,
      relatedBy: .equal,
      toItem: self,
      attribute: .height,
      multiplier: 0.15,
      constant: 0).isActive = true
    
    NSLayoutConstraint(
      item: departmentStackView!,
      attribute: .top,
      relatedBy: .equal,
      toItem: segmentControll,
      attribute: .bottom,
      multiplier: 1,
      constant: 10).isActive = true
    
    NSLayoutConstraint(
      item: departmentStackView!,
      attribute: .centerX,
      relatedBy: .equal,
      toItem: self,
      attribute: .centerX,
      multiplier: 1,
      constant: 0).isActive = true
    
    departmentStackView?.alignment = .fill
    departmentStackView?.distribution = .fillEqually
    departmentStackView?.axis = .vertical
    departmentStackView?.isHidden = true
  }
  
  private func setUpStackFields() {
    departmentName!.textColor = .black
    departmentName!.font = UIFont.boldSystemFont(ofSize: 17)
    departmentName!.clearButtonMode = .whileEditing
    departmentName!.textAlignment = .left
    departmentName!.placeholder = "Name"

    departmentManager!.textColor = .black
    departmentManager!.font = UIFont.boldSystemFont(ofSize: 17)
    departmentManager!.clearButtonMode = .whileEditing
    departmentManager!.textAlignment = .left
    departmentManager!.placeholder = "Select manager"
  }
  
  private func laidOutSegment() {
    segmentControll?.translatesAutoresizingMaskIntoConstraints = false
    addSubview(segmentControll!)
    
    NSLayoutConstraint(
      item: segmentControll!,
      attribute: .height,
      relatedBy: .equal,
      toItem: self,
      attribute: .height,
      multiplier: 0.05,
      constant: 0).isActive = true
    
    NSLayoutConstraint(
      item: segmentControll!,
      attribute: .width,
      relatedBy: .equal,
      toItem: self,
      attribute: .width,
      multiplier: 0.4,
      constant: 0).isActive = true
    
    NSLayoutConstraint(
      item: segmentControll!,
      attribute: .top,
      relatedBy: .equal,
      toItem: self,
      attribute: .top,
      multiplier: 0.4,
      constant: 0).isActive = true
    
    NSLayoutConstraint(
      item: segmentControll!,
      attribute: .centerX,
      relatedBy: .equal,
      toItem: self,
      attribute: .centerX,
      multiplier: 1,
      constant: 0).isActive = true

    segmentControll!.insertSegment(withTitle: "Employee", at: segmentControll!.numberOfSegments, animated: false)
    segmentControll!.insertSegment(withTitle: "Department", at: segmentControll!.numberOfSegments, animated: false)
    segmentControll?.contentHorizontalAlignment = .center
    segmentControll?.contentVerticalAlignment = .center
    segmentControll?.selectedSegmentIndex = SelectStates.employee.rawValue
    segmentControll?.apportionsSegmentWidthsByContent = true
    
    segmentControll?.addTarget(self, action: #selector(toggleVisibleStack), for: .valueChanged)
  }
}
