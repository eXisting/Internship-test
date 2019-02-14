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
  
  override func loadView() {
    super.loadView()
    self.title = titleName
    
    mainView = AddEntityView(frame: self.view.frame)
    self.view = mainView
    
    addTargets()
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(save))
  }
  
  private func addTargets() {
    mainView.departmentManager?.addTarget(self, action: #selector(selectManager), for: .touchDown)
  }
  
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
  
  private func onSelectManager(_ manager: String) {
    mainView.departmentManager?.text = manager
  }
  
  @objc func toggleState() {
    mainView.toggleVisibleStack()
  }
}
