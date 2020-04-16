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

// MARK: - Table View data source, delegate
extension UIViewController: UITableViewDataSource, UITableViewDelegate {
  
  public func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "section # \(section)"
  }
  
//  public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//    let headerView = UIView()
//    headerView.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
//
//    return headerView
//  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let idCell = "caseCell"
    
    let cell = tableView.dequeueReusableCell(withIdentifier: idCell) as! CaseTableViewCell
    cell.titleLabel.text = "title"
    return cell
  }
  
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 62.0
  }
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(indexPath.row)
  }
    
}
