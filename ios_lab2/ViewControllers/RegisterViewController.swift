//
//  RegisterViewController.swift
//  ios_lab2
//
//  Created by Frostjaw on 10/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
  
  @IBOutlet weak var nameTextField: TextFieldWithBottomBorder!
  @IBOutlet weak var mailTextField: TextFieldWithBottomBorder!
  @IBOutlet weak var passwordTextField: TextFieldWithBottomBorder!
  @IBOutlet weak var repeatPasswordTextField: TextFieldWithBottomBorder!
  
  let backendService = BackendService()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  @IBAction func registerButtonTouchDown(_ sender: Any) {
    guard let name = nameTextField.text, !name.isEmpty else {
      showAlert(message: GlobalConstants.emptyNameMessage)
      return
    }
    guard let mail = mailTextField.text, !mail.isEmpty else{
      showAlert(message: GlobalConstants.emptyEmailMessage)
      return
    }
    guard isValidEmail(email: mail) else {
      showAlert(message: GlobalConstants.invalidEmailMessage)
      return
    }
    guard let password = passwordTextField.text, !password.isEmpty else {
      showAlert(message: GlobalConstants.emptyPasswordMessage)
      return
    }
    guard let repeatPassword = repeatPasswordTextField.text, !repeatPassword.isEmpty else {
      showAlert(message: GlobalConstants.emptyRePasswordMessage)
      return
    }
    guard password == repeatPassword else {
      showAlert(message: GlobalConstants.passwordsNotMatchMessage)
      return
    }
    
    backendService.registerUser(email: mail, name: name, password: password) { result in
      switch result {
      case .failure(let error):
        self.showAlert(message: error.localizedDescription)
        
      case .success(let response):
        self.saveUserData(login: self.mailTextField.text!, password: self.mailTextField.text!, token: response.token)        
        self.openMainViewController()
      }
    }
    
  }
  
}
