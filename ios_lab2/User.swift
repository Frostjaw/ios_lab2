//
//  User.swift
//  ios_lab2
//
//  Created by Frostjaw on 14/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import Foundation

class User {
  var login: String?
  var password: String?
  var token: String?
  
  init(login: String, password: String, token: String) {
    self.login = login
    self.password = password
    self.token = token
  }
  
  func saveData() {
    let defaults = UserDefaults.standard
    defaults.set(self.login, forKey: "login")
    defaults.set(self.password, forKey: "password")
    defaults.set(self.token, forKey: "token")
  }
}
