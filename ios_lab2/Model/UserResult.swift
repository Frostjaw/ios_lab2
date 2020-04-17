//
//  UserResult.swift
//  ios_lab2
//
//  Created by Frostjaw on 15/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import Foundation

struct UserResult {
  let login: String?
  let token: String?
  
}

extension UserResult: Decodable {
  enum CodingKeys: String, CodingKey {
    case login = "email"
    case token = "api_token"
  }
  
  init(from: Decoder) throws {
    let values = try from.container(keyedBy: CodingKeys.self)
    self.login = try values.decodeIfPresent(String.self, forKey: .login)
    self.token = try values.decode(String.self, forKey: .token)
  }
}
