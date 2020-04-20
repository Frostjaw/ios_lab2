//
//  TokenResult.swift
//  ios_lab2
//
//  Created by Frostjaw on 19/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import Foundation

struct TokenResult {
  var token: String
}

extension TokenResult: Decodable {
  enum CodingKeys: String, CodingKey {
    case token = "api_token"
  }
  
  init(from: Decoder) throws {
    let values = try from.container(keyedBy: CodingKeys.self)
    self.token = try values.decode(String.self, forKey: .token)
  }
}
