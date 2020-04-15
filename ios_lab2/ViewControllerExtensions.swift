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
}
