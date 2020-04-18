//
//  Category.swift
//  ios_lab2
//
//  Created by Frostjaw on 17/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import Foundation

struct Category {
  var id: Int
  var name: String
  var tasks: [Task]?
}

extension Category: Decodable {
  enum CodingKeys: String, CodingKey {
    case id
    case name
  }
  
  init(from: Decoder) throws {
    let values = try from.container(keyedBy: CodingKeys.self)
    self.id = try values.decode(Int.self, forKey: .id)
    self.name = try values.decode(String.self, forKey: .name)
  }
}

