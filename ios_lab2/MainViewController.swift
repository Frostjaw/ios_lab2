//
//  MainViewController.swift
//  ios_lab2
//
//  Created by Frostjaw on 14/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import UIKit
import Kingfisher

class MainViewController: UIViewController {
  
  @IBOutlet weak var placeholderImageView: UIImageView!
  @IBOutlet weak var imageLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavigationBar()
    loadImage()
    setupTableView()
  }
  
  func loadImage() {    
    let url = URL(string: "https://loremflickr.com/640/480/holiday")
    let processor = RoundCornerImageProcessor(cornerRadius: 10)
    placeholderImageView.kf.indicatorType = .activity
    placeholderImageView.kf.setImage(
        with: url,
        options: [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale)
        ])
    
    imageLabel.isHidden = false
  }
  
  func setupNavigationBar () {
    let navigationBar = navigationController?.navigationBar    
    navigationBar?.barTintColor = #colorLiteral(red: 1, green: 0.5843137255, blue: 0, alpha: 1)
    navigationBar?.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    let titleLabel = UILabel()
    titleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    titleLabel.font = UIFont.boldSystemFont(ofSize: 28.0)
    titleLabel.text = "Not Forgot!";
    
    self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
  }
  
  @objc func addTapped() {
    
  }
  
  func setupTableView() {
    
    let idCell = "caseCell"
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(UINib(nibName: "CaseTableViewCell", bundle: nil), forCellReuseIdentifier: idCell)
  }
  
}
