//
//  AddMoreViewController.swift
//  inern
//
//  Created by Andrey Popazov on 2/12/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

class AddMoreViewController: UIViewController {
  private(set) var mainView: AddEntityView!
  
  private let titleName = "Add more"
  lazy var imagePicker = UIImagePickerController()
  
  override func loadView() {
    super.loadView()
    self.title = titleName
    
    mainView = AddEntityView(frame: self.view.frame)
    self.view = mainView
    
    addTargets()
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(save))
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func addTargets() {
    mainView.departmentManager?.addTarget(self, action: #selector(selectManager), for: .touchDown)
    let singleTap = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
    mainView.employeeProfileView?.addGestureRecognizer(singleTap)
  }
  
  // MARK: - Objc methods
  
  @objc func save() {
    self.navigationController?.popViewController(animated: true)
    // TODO: Call core data
    print("saved")
  }
  
  @objc func selectManager() {
    let controller = ManagerTableViewController()
    controller.onCellSelect = onSelectManager
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  @objc func toggleState() {
    mainView.toggleVisibleStack()
  }

  @objc func chooseImage() {
    let cameraAction =  UIAlertAction(title: "Camera", style: .default, handler: { _ in
      self.openCamera()
    })
    
    let galleryAction = UIAlertAction(title: "Gallery", style: .default, handler: { _ in
      self.openGallary()
    })

    AlertController.showChoose(for: self, title: "Choose image", cameraAction, galleryAction)
    
    imagePicker.delegate = self
    imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
    imagePicker.allowsEditing = false
  }
  
  private func onSelectManager(_ manager: String) {
    mainView.departmentManager?.text = manager
  }
}
