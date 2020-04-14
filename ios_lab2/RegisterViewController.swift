//
//  RegisterViewController.swift
//  ios_lab2
//
//  Created by Frostjaw on 10/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
  
  @IBOutlet weak var loginTextField: TextFieldWithBottomBorder!
  @IBOutlet weak var mailTextField: TextFieldWithBottomBorder!
  @IBOutlet weak var passwordTextField: TextFieldWithBottomBorder!
  @IBOutlet weak var repeatPasswordTextField: TextFieldWithBottomBorder!
  
  let backendService = BackendService()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  @IBAction func registerButtonTouchDown(_ sender: Any) {
    guard let login = loginTextField.text, !login.isEmpty else {
      showAlert(message: "Введите логин")
      return
    }
    guard let mail = mailTextField.text, !mail.isEmpty else{
      showAlert(message: "Введите почту")
      return
    }
    guard let password = passwordTextField.text, !password.isEmpty else {
      showAlert(message: "Введите пароль")
      return
    }
    guard let repeatPassword = repeatPasswordTextField.text, !repeatPassword.isEmpty else {
      showAlert(message: "Введите пароль повторно")
      return
    }
    guard password == repeatPassword else {
      showAlert(message: "Пароли не совпадают")
      return
    }
    
    backendService.registerUser(email: mail, name: login, password: password) { result in
      switch result {
      case .failure(let error):
        print(error)
        
      case .success(let response):
        //print(response)
        self.showAlert(message: response["message"] as! String)
      }
    }
    
  }
  
}
