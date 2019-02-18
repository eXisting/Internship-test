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
  
  private(set) var employeeProfileView: EmployeeProfile?
  private var departmentStackView: UIStackView?
  
  private(set) var departmentName: UITextField?
  private(set) var departmentManager: UITextField?
  
  var manager: Employee? {
    didSet {
      departmentManager?.text = manager?.name
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    laidOutViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func getFieldsDataAsDict() -> [String: Any] {
    return segmentControll?.selectedSegmentIndex == SelectStates.employee.rawValue ?
      employeeProfileView!.getFieldsDataAsDict() : getDepartmentFieldsAsDict()
  }
  
  private func getDepartmentFieldsAsDict() -> [String: Any] {
    return ["name": departmentName!.text as Any]
  }
  
  @objc func toggleVisibleStack() {
    departmentStackView?.isHidden = !departmentStackView!.isHidden
    employeeProfileView?.isHidden = !employeeProfileView!.isHidden
  }
  
  private func laidOutViews() {
    laidOutSegment()
    laidOutStacks()
    laidOutTextFields()
  }
  
  private func laidOutStacks() {
    let employeeStackSize = CGSize(width: self.frame.width, height: self.frame.height * 0.7)
    let departmentStackSize = CGSize(width: self.frame.width * 0.65, height: self.frame.height * 0.15)

    let originY = segmentControll!.frame.height + segmentControll!.frame.origin.y
    let orignEmployeeStack = CGPoint(x: 0, y: originY)
    let originDepartmentStack = CGPoint(x: self.frame.width * 0.1, y: originY)

    employeeProfileView = EmployeeProfile(frame: CGRect(origin: orignEmployeeStack, size: employeeStackSize))
    departmentStackView = UIStackView(frame: CGRect(origin: originDepartmentStack, size: departmentStackSize))
    
    departmentStackView?.alignment = .fill
    departmentStackView?.distribution = .fillEqually
    departmentStackView?.axis = .vertical
    departmentStackView?.isHidden = true
    
    addSubview(employeeProfileView!)
    addSubview(departmentStackView!)
  }
  
  private func laidOutTextFields() {
    departmentName = UITextField()
    departmentManager = UITextField()

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

    departmentStackView!.addArrangedSubview(departmentName!)
    departmentStackView!.addArrangedSubview(departmentManager!)
  }
  
  private func laidOutSegment() {
    let segmentSize = CGSize(width: self.frame.width * 0.35, height: self.frame.height * 0.05)
    let orign = CGPoint(x: self.frame.width * 0.05, y: self.frame.height * 0.1)
    
    segmentControll = UISegmentedControl(frame: CGRect(origin: orign, size: segmentSize))
    segmentControll!.insertSegment(withTitle: "Employee", at: segmentControll!.numberOfSegments, animated: false)
    segmentControll!.insertSegment(withTitle: "Department", at: segmentControll!.numberOfSegments, animated: false)
    segmentControll?.contentHorizontalAlignment = .center
    segmentControll?.contentVerticalAlignment = .center
    segmentControll?.selectedSegmentIndex = SelectStates.employee.rawValue
    segmentControll?.apportionsSegmentWidthsByContent = true
    
    segmentControll?.addTarget(self, action: #selector(toggleVisibleStack), for: .valueChanged)
    
    addSubview(segmentControll!)
  }
}
