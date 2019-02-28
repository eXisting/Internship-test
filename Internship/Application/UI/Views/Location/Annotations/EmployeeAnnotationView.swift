//
//  AnnotationView.swift
//  Internship
//
//  Created by sys-246 on 2/27/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import MapKit

class EmployeeAnnotationView: MKAnnotationView {
  
  weak var customCalloutView: AnnotationDataView?
  weak var delegate: SearchingPath?
  
  private let kPersonMapAnimationTime = 0.5

  override var annotation: MKAnnotation? {
    willSet {
      customCalloutView?.removeFromSuperview()
    }
  }
  
  // MARK: - life cycle
  
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    self.canShowCallout = false
    
    image = UIImage(named: "flag")?.imageResize(sizeChange: CGSize(width: 40, height: 40))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - callout showing and hiding
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    if selected {
      self.customCalloutView?.removeFromSuperview()
      
      if let newCustomCalloutView = initAnnotationView() {
        newCustomCalloutView.frame.origin.x = self.frame.width / 2.0 - newCustomCalloutView.frame.width / 2.0
        newCustomCalloutView.frame.origin.y = -newCustomCalloutView.frame.height
        
        // set custom callout view
        self.addSubview(newCustomCalloutView)
        self.customCalloutView = newCustomCalloutView
        self.customCalloutView?.employee = (annotation as! EmployeeAnnotation).employee
        
        // animate presentation
        if animated {
          self.customCalloutView!.alpha = 0.0
          UIView.animate(withDuration: kPersonMapAnimationTime, animations: {
            self.customCalloutView!.alpha = 1.0
          })
        }
      }
    } else {
      if customCalloutView != nil {
        if animated {
          UIView.animate(withDuration: kPersonMapAnimationTime, animations: {
            self.customCalloutView!.alpha = 0.0
          }, completion: { (success) in
            self.customCalloutView!.removeFromSuperview()
          })
        } else { self.customCalloutView!.removeFromSuperview() }
      }
    }
  }
  
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    if let parentHitView = super.hitTest(point, with: event) {
      return parentHitView
    }
    else {
      if customCalloutView != nil {
        return customCalloutView!.hitTest(convert(point, to: customCalloutView!), with: event)
      } else { return nil }
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.customCalloutView?.removeFromSuperview()
  }
  
  private func initAnnotationView() -> AnnotationDataView? {
    let view = AnnotationDataView(frame: CGRect(x: 0, y: 0, width: 140, height: 140))
    view.laidOutViews()
    view.delegate = delegate
    return view
  }
}
