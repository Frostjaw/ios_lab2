//
//  ViewControllerExtensions.swift
//  ios_lab2
//
//  Created by Frostjaw on 13/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import UIKit

// MARK: - Alerts
extension UIViewController {
  func showAlert(message: String) {
    let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Закрыть", style: .default, handler: nil))
    self.present(alert, animated: true)
  }
  
  func showExitAlert(message: String) {
    let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Закрыть",
                                  style: .default,
                                  handler: {(alert: UIAlertAction) in exit(0) }))
    self.present(alert, animated: true)
  }
}

// MARK: - Email validation
extension UIViewController {
  func isValidEmail(email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
  }
}

// MARK: - Open main viewcontroller
extension UIViewController {
  func openMainViewController() {
    let mainViewController = MainViewController()
    let navigationController = UINavigationController(rootViewController: mainViewController)
    self.present(navigationController, animated: true, completion: nil)
  }
  
  func openLogInViewController() {
    let logInViewController = LogInViewController()
    self.present(logInViewController, animated: true, completion: nil)
  }
}

// MARK: - user data
extension UIViewController {
  func saveUserData(login: String, password: String, token: String) {
    let defaults = UserDefaults.standard
    defaults.set(login, forKey: "login")
    defaults.set(password, forKey: "password")
    defaults.set(token, forKey: "token")
  }
  
  func deleteUserData() {
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: "login")
    defaults.removeObject(forKey: "password")
    defaults.removeObject(forKey: "token")
  }
}

// MARK: - toast
extension UIViewController {
  
  enum ToastSettings {
    static let backgroundColor = UIColor.black.withAlphaComponent(0.6)
    static let textColor = UIColor.white
    static let font = UIFont.systemFont(ofSize: 17.0)
    static let messageAlpha: CGFloat = 1.0
    static let cornerRadius: CGFloat = 10
    static let duration = 4.0
    static let delay = 0.1
  }
  
  func showToast(message : String) {
    
    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height - 100, width: 300, height: 35))
    toastLabel.backgroundColor = ToastSettings.backgroundColor
    toastLabel.textColor = ToastSettings.textColor
    toastLabel.font = ToastSettings.font
    toastLabel.textAlignment = .center
    toastLabel.text = message
    toastLabel.alpha = ToastSettings.messageAlpha
    toastLabel.layer.cornerRadius = ToastSettings.cornerRadius
    toastLabel.clipsToBounds = true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: ToastSettings.duration, delay: ToastSettings.delay, options: .curveEaseOut, animations: {
      toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
      toastLabel.removeFromSuperview()
    })
  }
}

// MARK: - pass data protocol
protocol TaskDataEnteredDelegate: class {
  func userDidEnterInformation(data: Task)
}

// MARK: - button tapped protocol
protocol ButtonTappedDelegate: class {
  func buttonTapped(cell: CaseTableViewCell)
}
