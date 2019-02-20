//
//  ReusableHeader.swift
//  Internship
//
//  Created by sys-246 on 2/14/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

protocol ExandableHeaderViewDelegate {
  func toogleExpand(for header: ReusableHeader, section: Int)
}

protocol DeletableHeaderDelegate {
  func deleteSection(section: Int)
}

class ReusableHeader: UITableViewHeaderFooterView {  
  var data: SectionData! {
    didSet {
      textLabel?.text = data.department.name
    }
  }
  
  var deleteButton: UIButton!
  
  var collapseDelegate: ExandableHeaderViewDelegate!
  var deleteDelegate: DeletableHeaderDelegate!
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSelectHeader)))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupDelButton(_ parentHeight: CGFloat, _ parentWidth: CGFloat) {
    let buttonFrame = CGRect(x: parentWidth, y: parentHeight * 0.4, width: 50, height: parentHeight / 4)
    let deleteButton = UIButton(frame: buttonFrame)
    
    deleteButton.setTitle("Del", for: .normal)
    deleteButton.backgroundColor = .red
    deleteButton.tag = data.section
    
    deleteButton.addTarget(self, action: #selector(onDeleteSection), for: .touchUpInside)
    
    addSubview(deleteButton)
  }
  
  @objc func onSelectHeader(recognizer: UITapGestureRecognizer) {
    let cell = recognizer.view as! ReusableHeader
    collapseDelegate.toogleExpand(for: cell, section: cell.data.section)
  }
  
  @objc func onDeleteSection(_ sender: UIButton) {
    deleteDelegate.deleteSection(section: sender.tag)
  }
}
