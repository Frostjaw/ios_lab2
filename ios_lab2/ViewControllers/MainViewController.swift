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
  
  enum Constants {
    static let idCell = "caseCell"
    static let caseTableViewCellFileName = "CaseTableViewCell"
  }
  
  private let userId = UserDefaults.standard.string(forKey: "token")
  private let taskModel = TaskModel()
  private var categories = [Category]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard taskModel.backendService.isConnectedToInternet() else {
      self.showExitAlert(message: "Отсутствует интернет соединение")
      return
    }
    taskModel.delegate = self
    taskModel.requestData(id: userId!)
    
    self.setupNavigationBar()
    self.setupTableView()
    self.loadImage()
    
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
    
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Not Forgot!", style: .plain, target: self, action: nil)
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    let logOutButton = UIBarButtonItem(title: "Выход", style: .plain, target: self, action: #selector(logOut))
    self.navigationItem.rightBarButtonItems = [logOutButton, addButton]
  }
  
  
  @objc func addTapped() {
    self.navigationController?.pushViewController(CreateTaskViewController(), animated: true)
  }
  
  @objc func logOut() {
    self.deleteUserData()
    self.openLogInViewController()
  }
  
  func setupTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(UINib(nibName: Constants.caseTableViewCellFileName, bundle: nil), forCellReuseIdentifier: Constants.idCell)
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
    tableView.refreshControl = refreshControl
  }
  
  @objc func refreshTable() {
    
    //reload data here
    tableView.reloadData()
    tableView.refreshControl?.endRefreshing()
  }
  
}

// MARK: - Table View data source, delegate
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
  
  // MARK: - sections/cells
  public func numberOfSections(in tableView: UITableView) -> Int {
    return categories.count
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories[section].tasks?.count ?? 0
  }
  
  public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return categories[section].name
  }
  
  // MARK: - create cell
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.idCell) as! CaseTableViewCell
    cell.colorView.backgroundColor = hexStringToUIColor(hex: categories[indexPath.section].tasks?[indexPath.row].priority.color ?? "#FFFFFF")
    cell.titleLabel.text = categories[indexPath.section].tasks?[indexPath.row].title
    cell.subTitleLabel.text = categories[indexPath.section].tasks?[indexPath.row].description
    return cell
  }
  
  // MARK: - cells height
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 62.0
  }
  
  // MARK: - select cell
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let taskDetailsViewController = TaskDetailsViewController()
    taskDetailsViewController.task = categories[indexPath.section].tasks?[indexPath.row]
    self.navigationController?.pushViewController(taskDetailsViewController, animated: true)
    self.tableView.deselectRow(at: indexPath, animated: true)
  }
  
  // MARK: - swipe-to-delete
  public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    true
  }
  
  public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      categories[indexPath.section].tasks!.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
  
}

// MARK: - task model delegate
extension MainViewController: TaskModelDelegate {
  func didReceiveDataUpdate(data: [Category]){
    
    self.categories = data
    guard self.categories.isEmpty else {
      placeholderImageView.isHidden = true
      imageLabel.isHidden = true
      tableView.isHidden = false
      tableView.reloadData()
      return
    }

  }
  
}

// MARK: - convert hex string to UIColor
extension MainViewController {
  func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
      cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
      return UIColor.gray
    }
    
    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    return UIColor(
      red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }
  
}

