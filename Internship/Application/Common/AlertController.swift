//
//  AlertController.swift
//  Internship
//
//  Created by sys-246 on 2/14/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

class AlertController {
  
  private class func createConfirmDialog(
    _ title: String,
    _ message: String,
    _ style: UIAlertController.Style,
    _ completion: @escaping (UIAlertAction) -> Void) -> UIAlertController {
    
    let alert = UIAlertController(
      title: title,
      message: message,
      preferredStyle: UIAlertController.Style.alert)
    
    alert.addAction(UIAlertAction(
      title: "OK",
      style: UIAlertAction.Style.default,
      handler: completion))
    
    return alert
  }
  
  private class func createChooseDialog(
    _ title: String,
    _ firstAction: UIAlertAction,
    _ secondAction: UIAlertAction,
    _ cancelAction: UIAlertAction?) -> UIAlertController {
    
    let alert = UIAlertController(
      title: title,
      message: nil,
      preferredStyle: UIAlertController.Style.actionSheet)
    
    alert.addAction(firstAction)
    alert.addAction(secondAction)
    alert.addAction(cancelAction ?? UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    return alert
  }
  
  static func showConfirm(
    for viewController: UIViewController,
    _ title: String,
    _ message: String,
    _ style: UIAlertController.Style,
    _ completion: @escaping (UIAlertAction) -> Void) {
    
    viewController.present(
      createConfirmDialog(title, message, .alert, completion),
      animated: true,
      completion: nil)
  }
  
  static func showChoose(
    for viewController: UIViewController,
    title: String,
    _ firstAction: UIAlertAction,
    _ secondAction: UIAlertAction,
    _ cancelAction: UIAlertAction? = nil) {
    
    viewController.present(
      createChooseDialog(title, firstAction, secondAction, cancelAction),
      animated: true,
      completion: nil)
  }
}
