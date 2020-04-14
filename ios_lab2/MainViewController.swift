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
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavigationBar()
    loadImage()
    //loadNavigationBar()
    //loadNavigationController()
  }
  
  func loadImage() {    
    let url = URL(string: "https://loremflickr.com/640/480/holiday")
    let processor = DownsamplingImageProcessor(size: placeholderImageView.bounds.size)
      |> RoundCornerImageProcessor(cornerRadius: 10)
    placeholderImageView.kf.indicatorType = .activity
    placeholderImageView.kf.setImage(
        with: url,
        options: [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale)
        ])
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
  
//  func loadNavigationController() {
//    let navController = UINavigationController(rootViewController: self)
//  }
//
//  func loadNavigationBar() {
//
//    let screenWidth = UIScreen.main.bounds.size.width
//
//    let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 140))
//    navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.5843137255, blue: 0, alpha: 1)
//    view.addSubview(navigationBar)
//
//    let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
//    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
//
//    let navigationItem = UINavigationItem(title: "Title")
//    navigationItem.leftBarButtonItem = cancelButton
//    navigationItem.rightBarButtonItem = doneButton
//
//    navigationBar.items = [navigationItem]
//  }
  
}
