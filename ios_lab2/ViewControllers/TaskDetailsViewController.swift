//
//  TaskDetailsViewController.swift
//  ios_lab2
//
//  Created by Frostjaw on 19/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import UIKit

class TaskDetailsViewController: UIViewController {
  
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
    
    setupNavigationBar()
    setupLabels()
  }
  
  
  @IBAction func editButtonTouchDown(_ sender: Any) {
    let editTaskViewController = EditTaskViewController()
    editTaskViewController.task = self.task
    self.navigationController?.pushViewController(editTaskViewController, animated: true)
  }
  
  private func setupNavigationBar () {
    
    let titleLabel = UILabel()
    titleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
    titleLabel.text = task?.title;
    self.navigationItem.titleView = titleLabel
  }
  
  private func setupLabels() {
    setupCreatedLabel()
    setupDoneLabel()
    setupDescriptionTextView()
    setupCategoryLabel()
    setupDeadLineLabel()
    setupPriorityButton()
  }
  
  private func setupCreatedLabel() {
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .none
    dateFormatter.dateStyle = .short
    let timeString = dateFormatter.string(from: Date(timeIntervalSince1970: Double(task!.created)))
    createdLabel.text = timeString
  }
  
  private func setupDoneLabel() {
    if task?.done == 0 {
      doneLabel.text = "Не выполнено"
    } else if task?.done == 1{
      doneLabel.text = "Выполнено"
    }

  }
  
  private func setupDescriptionTextView() {
    descriptionTextView.text = task?.description
  }
  
  private func setupCategoryLabel() {
    categoryLabel.text = task?.category.name
  }
  
  private func setupDeadLineLabel(){
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .none
    dateFormatter.dateStyle = .short
    let timeString = dateFormatter.string(from: Date(timeIntervalSince1970: Double(task!.created)))
    deadLineLabel.text = "До \(timeString)"
  }
  
  private func setupPriorityButton() {
    priorityButton.setCornerRadius(cornerRadius: CGFloat(4))
    priorityButton.setTitle(task?.priority.name, for: .normal)
  }
  
}
