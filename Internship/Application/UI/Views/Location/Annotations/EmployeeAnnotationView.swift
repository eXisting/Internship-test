//
//  AnnotationView.swift
//  Internship
//
//  Created by sys-246 on 2/27/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import MapKit

class EmployeeAnnotationView: MKAnnotationView {
  // data
  weak var customCalloutView: AnnotationDataView?
  
  override var annotation: MKAnnotation? {
    willSet { customCalloutView?.removeFromSuperview() }
  }
  
  let kPersonMapAnimationTime = 0.5
  
  // MARK: - life cycle
  
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    self.canShowCallout = false
    
    image = UIImage(named: "flag")?.imageResize(sizeChange: CGSize(width: 64, height: 64))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - callout showing and hiding
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    if selected {
      self.customCalloutView?.removeFromSuperview() // remove old custom callout (if any)
      
      if let newCustomCalloutView = loadPersonDetailMapView() {
        // fix location from top-left to its right place.
        newCustomCalloutView.frame.origin.x -= newCustomCalloutView.frame.width / 2.0 - (self.frame.width / 2.0)
        newCustomCalloutView.frame.origin.y -= newCustomCalloutView.frame.height
        
        // set custom callout view
        self.addSubview(newCustomCalloutView)
        self.customCalloutView = (newCustomCalloutView as! AnnotationDataView)
        
        // animate presentation
        if animated {
          self.customCalloutView!.alpha = 0.0
          UIView.animate(withDuration: kPersonMapAnimationTime, animations: {
            self.customCalloutView!.alpha = 1.0
          })
        }
      }
    } else { // 3
      if customCalloutView != nil {
        if animated { // fade out animation, then remove it.
          UIView.animate(withDuration: kPersonMapAnimationTime, animations: {
            self.customCalloutView!.alpha = 0.0
          }, completion: { (success) in
            self.customCalloutView!.removeFromSuperview()
          })
        } else { self.customCalloutView!.removeFromSuperview() } // just remove it.
      }
    }
  }
  
  func loadPersonDetailMapView() -> UIView? {
    let view = AnnotationDataView(frame: CGRect(x: 0, y: 0, width: 240, height: 280))
    
    //TODO: INIT
    return view
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.customCalloutView?.removeFromSuperview()
  }
}
