//
//  LogInViewController.swift
//  ios_lab2
//
//  Created by Frostjaw on 09/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
  
  @IBOutlet weak var mailTextField: TextFieldWithBottomBorder!
  @IBOutlet weak var passwordTextField: TextFieldWithBottomBorder!
  @IBOutlet weak var signUpButton: RoundedButton!
  
  let backendService = BackendService()
  
  @IBAction func logInButtonTouchDown(_ sender: Any) {
    guard let mail = mailTextField.text, !mail.isEmpty else {
      showAlert(message: "Введите почту")
      return
    }
    guard let password = passwordTextField.text, !password.isEmpty else{
      showAlert(message: "Введите пароль")
      return
    }
    
    backendService.loginUser(email: mail, password: password)
    
  }
  
  @IBAction func signUpButtonTouchDown(_ sender: Any) {
    let registerViewController = RegisterViewController()
    self.present(registerViewController, animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
}
