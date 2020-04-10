//
//  LogInViewController.swift
//  ios_lab2
//
//  Created by Frostjaw on 09/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
  
  // MARK: - constants
  
  enum Constants {
    static let containerViewCornerRadius = CGFloat(3)
    static let buttonsCornerRadius = CGFloat(8)
  }
  
  @IBOutlet weak var logInContainerView: UIView!
  @IBOutlet weak var logInButton: UIButton!
  @IBOutlet weak var signUpButton: UIButton!
  
  
  @IBAction func signUpButtonTouchDown(_ sender: Any) {
    let registerViewController = RegisterViewController()
    self.present(registerViewController, animated: true, completion: nil)
    //test
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    launchLogInContainerView()
    launchButtons()
    
  }
  
  private func launchLogInContainerView(){
    logInContainerView.layer.cornerRadius = Constants.containerViewCornerRadius
  }
  
  private func launchButtons(){
    logInButton.layer.cornerRadius = Constants.buttonsCornerRadius
    signUpButton.layer.cornerRadius = Constants.buttonsCornerRadius
  }
  
}
