//
//  EditTaskViewController.swift
//  ios_lab2
//
//  Created by Frostjaw on 20/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import UIKit

class EditTaskViewController: UIViewController {
  
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
  @IBOutlet weak var datePickerView: UIDatePicker!
    
  private let userId = UserDefaults.standard.string(forKey: "token")
  private let backendService = BackendService()
  private var availableCategories = [Category]()
  private var availablePriorities = [Priority]()
  private var isCategoryButtonSelected = false
  private var isPriorityButtonSelected = false
  var task: Task?
  
  let datePicker = UIDatePicker()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.pickerView.delegate = self
    self.pickerView.dataSource = self
    setupNavigationBar()
    setupLabels()
  }
  
  private func setupNavigationBar () {
    let titleLabel = UILabel()
    titleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
    titleLabel.text = "Изменить заметку";
    self.navigationItem.titleView = titleLabel
  }
  
  private func setupLabels() {
    setupTitleTextField()
    setupDescriptionTextView()
    setupCategoryButton()
    setupAddCategoryButton()
    setupPriorityButton()
    setupDeadLineTextField()
  }
  
  private func setupTitleTextField() {
    titleTextField.text = task?.title
  }
  
  private func setupDescriptionTextView() {
    descriptionTextView.text = task?.description
  }
  
  private func setupCategoryButton(){
    categoryButton.setTitle(task?.category.name, for: .normal)
    
    backendService.getCategories(id: userId!) { result in
      switch result {
      case .failure(let error):
        self.showAlert(message: error.localizedDescription)
        
      case .success(let response):
        self.availableCategories = response
      }
    }

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
    
    let alert = UIAlertController(title: "Добавить категорию", message: "Введите название новой категории", preferredStyle: .alert)
    alert.addTextField { (textField) in
      textField.placeholder = "Категория"
    }
    alert.addAction(UIAlertAction(title: "Отмена", style: .default, handler: nil))
    alert.addAction(UIAlertAction(title: "Сохранить",
                                  style: .default,
                                  handler: {[weak alert] (_) in self.addCategory(name: (alert?.textFields![0].text)!) }))
    self.present(alert, animated: true)
  }
  
  private func addCategory(name: String) {
    backendService.postCategory(name: name) { result in
      switch result {
      case .failure(let error):
        self.showAlert(message: error.localizedDescription)
        
      case .success(let response):
        self.showAlert(message: "Категория добавлена")
        self.task?.category = response
      }
    }
    
  }
  
  private func setupPriorityButton() {
    priorityButton.setTitle(task?.priority.name, for: .normal)
    
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
    
    deadLineTextField.addTarget(self, action: #selector(deadLineTextFieldTouchDown), for: .touchDown)
    
    deadLineTextField.inputView = datePicker
    datePicker.datePickerMode = .date
    
    let toolbar = UIToolbar()
    toolbar.barStyle = .default
    toolbar.sizeToFit()
    let acceptButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(acceptDate))
    //let acceptButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(acceptDate))
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

extension EditTaskViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
    
    var titleForRow = "default title"
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
      task?.category = availableCategories[row]
      categoryButton.setTitle(task?.category.name, for: .normal)
      isCategoryButtonSelected = false
    } else if isPriorityButtonSelected {
      task?.priority = availablePriorities[row]
      priorityButton.setTitle(task?.priority.name, for: .normal)
      isPriorityButtonSelected = false
    }
    hidePickerView()
  }
  
}

// MARK: - fade in/fade out
extension EditTaskViewController {
  
  func fade(view: UIView, hidden: Bool) {
    UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
      view.isHidden = hidden
    })
  }
}
