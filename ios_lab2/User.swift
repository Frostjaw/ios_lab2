//
//  User.swift
//  ios_lab2
//
//  Created by Frostjaw on 14/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import Foundation

class User {
  var login: String
  var mail: String
  var token: String?
  
  init(login: String, mail: String) {
    self.login = login
    self.mail = mail
  }
}
