//
//  CreateTaskViewController.swift
//  ios_lab2
//
//  Created by Frostjaw on 19/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupNavigationBar()
  }
  
  private func setupNavigationBar () {
    let titleLabel = UILabel()
    titleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
    titleLabel.text = "Добавить заметку";    
    self.navigationItem.titleView = titleLabel
  }
  
}
