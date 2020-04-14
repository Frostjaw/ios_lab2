//
//  ViewControllerExtensions.swift
//  ios_lab2
//
//  Created by Frostjaw on 13/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(message: String) {
    let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Закрыть", style: .default, handler: nil))
    self.present(alert, animated: true)
  }
}
