//
//  AnnotationDataView.swift
//  Internship
//
//  Created by sys-246 on 2/27/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit
import MapKit

class AnnotationDataView: UIView {

  weak var delegate: SearchingPath?
  weak var employee: Employee? {
    didSet {
      name.text = employee?.name
      phone.text = employee?.phone
    }
  }
  
  private var stackView = UIStackView()
  
  private let name = UILabel()
  private let phone = UILabel()
  
  private let findPath = UIButton()
  
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
  
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    // Check if it hit annotation view components
    
    // perform search
    if let _ = findPath.hitTest(convert(point, to: findPath), with: event) {
      onSearchClick()
    }
        
    return self
  }
  
  private func onSearchClick() {
    let coordinates = CLLocationCoordinate2D(latitude: employee!.location!.latitude, longitude: employee!.location!.longitude)
    let placemark = MKPlacemark(coordinate: coordinates)
    let destination = MKMapItem(placemark: placemark)
    
    delegate?.searchPath(to: destination)
  }
}
