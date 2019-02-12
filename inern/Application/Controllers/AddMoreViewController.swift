//
//  AddMoreViewController.swift
//  inern
//
//  Created by Andrey Popazov on 2/12/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit

class AddMoreViewController: UIViewController {
  override func loadView() {
    super.loadView()
    self.navigationItem.title = "Add more"
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(save))
  }
  
  @objc func save() {
    print("saved")
  }
}
