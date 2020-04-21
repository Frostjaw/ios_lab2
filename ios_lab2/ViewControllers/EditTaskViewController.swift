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
  
  enum Constants {
    static let limitOfCharactersInDescription = 120
  }
    
  private let userId = UserDefaults.standard.string(forKey: "token")
  private let backendService = BackendService()
  private var availableCategories = [Category]()
  private var availablePriorities = [Priority]()
  private var isCategoryButtonSelected = false
  private var isPriorityButtonSelected = false
  var task: Task?
  
  weak var delegate: TaskDataEnteredDelegate? = nil
  
  let datePicker = UIDatePicker()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.pickerView.delegate = self
    self.pickerView.dataSource = self
    setupNavigationBar()
    setupLabels()
  }
  
  @IBAction func saveButtonTouchDown(_ sender: Any) {
    guard let title = titleTextField.text else {
      showAlert(message: "Введите название")
      return
    }
    guard let description = descriptionTextView.text else {
      showAlert(message: "Введите описание")
      return
    }
    task?.title = title
    task?.description = description
    
    backendService.patchTask(taskId: task!.id, title: task!.title, description: task!.description, done: task!.done, deadline: task!.deadline, categoryId: task!.category.id, priorityId: task!.priority.id) { result in
      switch result {
      case .failure(let error):
        self.showAlert(message: error.localizedDescription)
        
      case .success(_):
        self.showToast(message: "Дело успешно сохранено")
        self.delegate?.userDidEnterInformation(data: self.task!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
          self.navigationController?.popViewController(animated: true)
        })
      }
    }
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
    descriptionTextView.delegate = self
    descriptionTextView.text = task?.description ?? ""    
    charactersNumberLabel.text = "\(descriptionTextView.text.count)/\(Constants.limitOfCharactersInDescription)"
  }
  
  private func setupCategoryButton() {
    categoryButton.setTitle(task?.category.name, for: .normal)
    refreshCategories()
  }
  
  private func refreshCategories() {
    self.backendService.getCategories(id: self.userId!) { result in
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
        self.refreshCategories()
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
    
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .none
    dateFormatter.dateStyle = .short
    let deadLineDateDouble = Double(self.task!.deadline)
    let deadLineDate = Date(timeIntervalSince1970: deadLineDateDouble)
    deadLineTextField.text = "До \(dateFormatter.string(from: deadLineDate))"
    
    deadLineTextField.addTarget(self, action: #selector(deadLineTextFieldTouchDown), for: .touchDown)
    deadLineTextField.inputView = datePicker
    datePicker.datePickerMode = .date
    datePicker.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    let toolbar = UIToolbar()
    toolbar.barStyle = .default
    toolbar.sizeToFit()
    let acceptButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(acceptDate))
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
    self.task?.deadline = Int(selectedDate.timeIntervalSince1970)
    
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

// MARK: - TextView delegate
extension EditTaskViewController: UITextViewDelegate {
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    guard let rangeOfTextToReplace = Range(range, in: textView.text) else {
      return false
    }
    let subStringToReplace = textView.text[rangeOfTextToReplace]
    let count = textView.text.count - subStringToReplace.count + text.count
    return count <= Constants.limitOfCharactersInDescription
  }
  
  func textViewDidChange(_ textView: UITextView) {
    let description = descriptionTextView.text ?? ""
    charactersNumberLabel.text = "\(description.count)/\(Constants.limitOfCharactersInDescription)"
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    self.task?.description = description
  }
  
}

extension EditTaskViewController {
  
  func showToast(message : String) {
    
    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-100, width: 300, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = UIFont.systemFont(ofSize: 17.0)
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
      toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
      toastLabel.removeFromSuperview()
    })
  }
}

