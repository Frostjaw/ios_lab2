//
//  CreateTaskViewController.swift
//  ios_lab2
//
//  Created by Frostjaw on 19/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController {
  
  enum LocalConstants {
    static let navigationBarTitleFont = UIFont.boldSystemFont(ofSize: 20.0)
    static let navogationBarTitle = "Создать заметку"
  }
  
  @IBOutlet weak var viewWithShadow: ViewWithShadow!
  @IBOutlet weak var titleTextField: TextFieldWithBottomBorder!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var categoryButton: RoundedButton!
  @IBOutlet weak var charactersNumberLabel: UILabel!
  @IBOutlet weak var priorityButton: RoundedButton!
  @IBOutlet weak var addPriorityImageView: UIImageView!
  @IBOutlet weak var deadLineTextField: UITextField!
  @IBOutlet weak var saveButton: RoundedButton!
  @IBOutlet weak var pickerView: UIPickerView!
  @IBOutlet weak var modalHelpView: UIView!
  
  private let userId = UserDefaults.standard.string(forKey: GlobalConstants.tokenKey)
  private let backendService = BackendService()
  private var availableCategories = [Category]()
  private var availablePriorities = [Priority]()
  private var isCategoryButtonSelected = false
  private var isPriorityButtonSelected = false
  var task = Task(id: -1, title: "", description: "", done: 0, deadline: -1, category: Category(id: -1, name: "", tasks: nil), priority: Priority(id: -1, name: "", color: ""), created: -1)
  
  weak var delegate: TaskDataEnteredDelegate? = nil
  
  let datePicker = UIDatePicker()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.pickerView.delegate = self
    self.pickerView.dataSource = self
    setupNavigationBar()
    setLabels()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    // MARK: - fixing shadow with portrait orientation
    DispatchQueue.main.async {
      self.viewWithShadow.addShadow(top: false, left: true, bottom: true, right: true)
    }
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    DispatchQueue.main.async {
          if UIDevice.current.orientation.isLandscape || UIDevice.current.orientation.isPortrait {
            self.viewWithShadow.addShadow(top: false, left: true, bottom: true, right: true)
      }
    }
  }
  
  @IBAction func saveButtonTouchDown(_ sender: Any) {
    guard let title = titleTextField.text, !title.isEmpty else {
      showAlert(message: GlobalConstants.emptyTaskTitleMessage)
      return
    }
    guard let description = descriptionTextView.text, !description.isEmpty else {
      showAlert(message: GlobalConstants.emptyTaskDescriptionMessage)
      return
    }
    guard self.task.category.id != -1 else {
      showAlert(message: GlobalConstants.emptyCategortMessage)
      return
    }
    guard self.task.category.id != -1 else {
      showAlert(message: GlobalConstants.emptyPriorityMessage)
      return
    }
    guard self.task.deadline != -1 else {
      showAlert(message: GlobalConstants.emptyDeadLineMessage)
      return
    }
    task.title = title
    task.description = description
    
    backendService.postTask(title: task.title, description: task.description, done: task.done, deadline: task.deadline, categoryId: task.category.id, priorityId: task.priority.id) { result in
      switch result {
      case .failure(let error):
        self.showAlert(message: error.localizedDescription)

      case .success(_):
        self.showToast(message: GlobalConstants.taskSuccessfullySavedMessage)
        self.delegate?.userDidEnterInformation(data: self.task)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
          self.navigationController?.popViewController(animated: true)
        })
      }
    }
  }
  
  private func setupNavigationBar () {
    let titleLabel = UILabel()
    titleLabel.textColor = GlobalConstants.navigationBarTintColor
    titleLabel.font = LocalConstants.navigationBarTitleFont
    titleLabel.text = LocalConstants.navogationBarTitle
    self.navigationItem.titleView = titleLabel
    
    self.navigationItem.hidesBackButton = true
    let backButton = UIBarButtonItem(title: "< \(GlobalConstants.applicationTitle)", style: .plain, target: self, action: #selector(back(sender:)))
    backButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0)], for: .normal)
    self.navigationItem.leftBarButtonItem = backButton
  }
  
  @objc func back(sender: UIBarButtonItem) {
    
    self.showSaveAlert(message: GlobalConstants.saveTaskMessage)    
  }
  
  private func setLabels() {
    setDescriptionTextView()
    setupCategoryButton()
    setupAddCategoryButton()
    setupPriorityButton()
    setupDeadLineTextField()
  }
  
  private func setDescriptionTextView() {
    descriptionTextView.delegate = self
    descriptionTextView.text = task.description
    charactersNumberLabel.text = "\(descriptionTextView.text.count)/\(GlobalConstants.limitOfCharactersInDescription)"
  }
  
  private func setupCategoryButton(){
    refreshCategories()
  }
  
  @IBAction func categoryButtonTouchDown(_ sender: Any) {
    isCategoryButtonSelected = true
    showPickerView()
  }
  
  private func setupAddCategoryButton() {
    let tapGestureRecogizer = UITapGestureRecognizer(target: self, action: #selector(addCategory(tapGestureRecognizer:)))
    addPriorityImageView.isUserInteractionEnabled = true
    addPriorityImageView.addGestureRecognizer(tapGestureRecogizer)
  }
  
  @objc func addCategory(tapGestureRecognizer: UITapGestureRecognizer) {
    
    let alert = UIAlertController(title: GlobalConstants.saveMessage, message: GlobalConstants.addCategoryAlertMessage, preferredStyle: .alert)
    alert.addTextField { (textField) in
      textField.placeholder = GlobalConstants.addCategoryAlertPlaceholder
    }
    alert.addAction(UIAlertAction(title: GlobalConstants.saveMessage,
                                  style: .default,
                                  handler: {[weak alert] (_) in
                                    self.addCategory(name: (alert?.textFields![0].text)!)
                                    
    }))
    alert.addAction(UIAlertAction(title: GlobalConstants.cancelMessage, style: .default, handler: nil))
    self.present(alert, animated: true)
  }
  
  private func addCategory(name: String) {
    backendService.postCategory(name: name) { result in
      switch result {
      case .failure(let error):
        self.showAlert(message: error.localizedDescription)
        
      case .success(let response):
        self.showAlert(message: GlobalConstants.categorySuccessfullyAddedMessage)
        self.task.category = response
        self.refreshCategories()
      }
    }
    
  }
  
  private func refreshCategories() {
    self.backendService.getCategories(id: userId!) { result in
      switch result {
      case .failure(let error):
        self.showAlert(message: error.localizedDescription)
        
      case .success(let response):
        self.availableCategories = response
      }
    }
  }
  
  private func setupPriorityButton() {
    backendService.getPriorities(id: userId!) { result in
      switch result {
      case .failure(let error):
        self.showAlert(message: error.localizedDescription)
        
      case .success(let response):
        self.availablePriorities = response
      }
    }
  }
  
  @IBAction func priorityButtonTouchDown(_ sender: Any) {
    isPriorityButtonSelected = true
    showPickerView()
  }
  
  private func setupDeadLineTextField() {
    
    deadLineTextField.addTarget(self, action: #selector(deadLineTextFieldTouchDown), for: .editingDidBegin)
    deadLineTextField.inputView = datePicker
    datePicker.datePickerMode = .date
    datePicker.backgroundColor = GlobalConstants.pickerBackgroundColor
    
    let toolbar = UIToolbar()
    toolbar.barStyle = .default
    toolbar.sizeToFit()
    let acceptButton = UIBarButtonItem(title: GlobalConstants.doneMessage, style: .done, target: self, action: #selector(acceptDate))
    toolbar.setItems([acceptButton], animated: true)
    deadLineTextField.inputAccessoryView = toolbar
  }
  
  @objc func deadLineTextFieldTouchDown() {
    fade(view: modalHelpView, hidden: false)
  }
  
  @objc func acceptDate() {
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .none
    dateFormatter.dateStyle = .short
    let selectedDate = datePicker.date
    deadLineTextField.text = "До \(dateFormatter.string(from: selectedDate))"
    self.task.deadline = Int(selectedDate.timeIntervalSince1970)
    
    fade(view: modalHelpView, hidden: true)
    view.endEditing(true)
  }
  
  private func showPickerView() {
    pickerView.reloadAllComponents()
    fade(view: pickerView, hidden: false)
    fade(view: modalHelpView, hidden: false)
  }
  
  private func hidePickerView() {
    pickerView.reloadAllComponents()
    fade(view: pickerView, hidden: true)
    fade(view: modalHelpView, hidden: true)
  }
}

extension CreateTaskViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
    var numberOfRowsInSection = 0
    if isCategoryButtonSelected {
      numberOfRowsInSection = availableCategories.count
    }
    if isPriorityButtonSelected {
      numberOfRowsInSection = availablePriorities.count
    }
    return numberOfRowsInSection
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    
    var titleForRow = ""
    if isCategoryButtonSelected {
      titleForRow = availableCategories[row].name
    }
    if isPriorityButtonSelected {
      titleForRow = availablePriorities[row].name
    }
    return titleForRow
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if isCategoryButtonSelected {
      task.category = availableCategories[row]
      categoryButton.setTitle(task.category.name, for: .normal)
      isCategoryButtonSelected = false
    } else if isPriorityButtonSelected {
      task.priority = availablePriorities[row]
      priorityButton.setTitle(task.priority.name, for: .normal)
      isPriorityButtonSelected = false
    }
    hidePickerView()
  }
  
}

// MARK: - fade in/fade out
extension CreateTaskViewController {
  
  func fade(view: UIView, hidden: Bool) {
    UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
      view.isHidden = hidden
    })
  }
}

// MARK: - TextView delegate
extension CreateTaskViewController: UITextViewDelegate {
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    guard let rangeOfTextToReplace = Range(range, in: textView.text) else {
      return false
    }
    let subStringToReplace = textView.text[rangeOfTextToReplace]
    let count = textView.text.count - subStringToReplace.count + text.count
    return count <= GlobalConstants.limitOfCharactersInDescription
  }
  
  func textViewDidChange(_ textView: UITextView) {
    let description = descriptionTextView.text ?? ""
    charactersNumberLabel.text = "\(description.count)/\(GlobalConstants.limitOfCharactersInDescription)"
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    self.task.description = description
  }
  
}

// MARK: - save alert
extension CreateTaskViewController {
  private func showSaveAlert(message: String) {
    
    let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: GlobalConstants.yesMessage,
                                  style: .default,
                                  handler:
      {(alert: UIAlertAction) in
        
        guard let title = self.titleTextField.text, !title.isEmpty else {
          self.showAlert(message: GlobalConstants.emptyTaskTitleMessage)
          return
        }
        guard let description = self.descriptionTextView.text, !description.isEmpty else {
          self.showAlert(message: GlobalConstants.emptyTaskDescriptionMessage)
          return
        }
        guard self.task.category.id != -1 else {
          self.showAlert(message: GlobalConstants.emptyCategortMessage)
          return
        }
        guard self.task.priority.id != -1 else {
          self.showAlert(message: GlobalConstants.emptyPriorityMessage)
          return
        }
        guard self.task.deadline != -1 else {
          self.showAlert(message: GlobalConstants.emptyDeadLineMessage)
          return
        }
        self.task.title = title
        self.task.description = description
        
        self.backendService.postTask(title: self.task.title, description: self.task.description, done: self.task.done, deadline: self.task.deadline, categoryId: self.task.category.id, priorityId: self.task.priority.id) { result in
          switch result {
          case .failure(let error):
            self.showAlert(message: error.localizedDescription)
            
          case .success(_):
            self.showToast(message: GlobalConstants.taskSuccessfullySavedMessage)
            self.navigationController?.popViewController(animated: true)
          }
        }
    }))
    
    alert.addAction(UIAlertAction(title: GlobalConstants.noMessage, style: .default, handler:
      {(alert: UIAlertAction) in
        self.navigationController?.popViewController(animated: true)
    }
    ))
    
    self.present(alert, animated: true)
  }
}
