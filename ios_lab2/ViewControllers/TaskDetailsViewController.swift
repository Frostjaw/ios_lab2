//
//  TaskDetailsViewController.swift
//  ios_lab2
//
//  Created by Frostjaw on 19/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import UIKit

class TaskDetailsViewController: UIViewController, TaskDataEnteredDelegate {
  
  private enum LocalConstants {
    static let navigationBarTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let navigationBarTitleFont = UIFont.boldSystemFont(ofSize: 20.0)
    static let doneLabel = "Выполнено"
    static let notDoneLabel = "Не выполнено"
  }
  
  @IBOutlet weak var viewWithShadow: ViewWithShadow!
  @IBOutlet weak var createdLabel: UILabel!
  @IBOutlet weak var doneLabel: UILabel!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var deadLineLabel: UILabel!
  @IBOutlet weak var priorityButton: RoundedButton!
  @IBOutlet weak var editTaskButton: RoundedButton!
  
  var task: Task?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  // MARK: - fixing shadow with portrait orientation
  override func viewWillAppear(_ animated: Bool) {
    DispatchQueue.main.async {
      self.viewWithShadow.addShadow(top: false, left: true, bottom: true, right: true)
    }
  
    setupNavigationBar()
    setLabels()
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    DispatchQueue.main.async {
          if UIDevice.current.orientation.isLandscape || UIDevice.current.orientation.isPortrait {
            self.viewWithShadow.addShadow(top: false, left: true, bottom: true, right: true)
      }
    }
  }  
  
  @IBAction func editButtonTouchDown(_ sender: Any) {
    let editTaskViewController = EditTaskViewController()
    editTaskViewController.delegate = self
    editTaskViewController.task = self.task
    self.navigationController?.pushViewController(editTaskViewController, animated: true)
  }
  
  private func setupNavigationBar () {
    
    let titleLabel = UILabel()
    titleLabel.textColor = LocalConstants.navigationBarTintColor
    titleLabel.font = LocalConstants.navigationBarTitleFont
    titleLabel.text = task?.title;
    self.navigationItem.titleView = titleLabel
    
    self.navigationItem.hidesBackButton = true
    let backButton = UIBarButtonItem(title: "< \(GlobalConstants.applicationTitle)", style: .plain, target: self, action: #selector(back(sender:)))
    backButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0)], for: .normal)
    self.navigationItem.leftBarButtonItem = backButton
  }
  
  @objc func back(sender: UIBarButtonItem) {
    self.navigationController?.popViewController(animated: true)
  }
  
  private func setLabels() {
    setCreatedLabel()
    setDoneLabel()
    setDescriptionTextView()
    setCategoryLabel()
    setDeadLineLabel()
    setPriorityLabel()
  }
  
  private func setCreatedLabel() {
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .none
    dateFormatter.dateStyle = .short
    let timeString = dateFormatter.string(from: Date(timeIntervalSince1970: Double(task!.created)))
    createdLabel.text = timeString
  }
  
  private func setDoneLabel() {
    if task?.done == 0 {
      doneLabel.text = LocalConstants.notDoneLabel
    } else if task?.done == 1 {
      doneLabel.text = LocalConstants.doneLabel
    }

  }
  
  private func setDescriptionTextView() {
    descriptionTextView.text = task?.description
  }
  
  private func setCategoryLabel() {
    categoryLabel.text = task?.category.name
  }
  
  private func setDeadLineLabel(){
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .none
    dateFormatter.dateStyle = .short
    let timeString = dateFormatter.string(from: Date(timeIntervalSince1970: Double(task!.created)))
    deadLineLabel.text = "До \(timeString)"
  }
  
  private func setPriorityLabel() {
    priorityButton.setCornerRadius(cornerRadius: CGFloat(4))
    priorityButton.setTitle(task?.priority.name, for: .normal)
  }
  
  func userDidEnterInformation(data: Task) {
    self.task? = data
  }
  
}

