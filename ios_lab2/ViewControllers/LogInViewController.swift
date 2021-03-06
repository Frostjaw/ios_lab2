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
      showAlert(message: GlobalConstants.emptyEmailMessage)
      return
    }
    guard isValidEmail(email: mail) else {
      showAlert(message: GlobalConstants.invalidEmailMessage)
      return
    }
    guard let password = passwordTextField.text, !password.isEmpty else{
      showAlert(message: GlobalConstants.emptyPasswordMessage)
      return
    }
    backendService.loginUser(email: mail, password: password) { result in
      switch result {
      case .failure(let error):
        self.showAlert(message: error.localizedDescription)
        
      case .success(let response):
        self.saveUserData(login: self.mailTextField.text!, password: self.mailTextField.text!, token: response.token)
        
        self.openMainViewController()
      }
    }
    
  }
  
  @IBAction func signUpButtonTouchDown(_ sender: Any) {
    let registerViewController = RegisterViewController()
    self.present(registerViewController, animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
}
