//
//  Task.swift
//  ios_lab2
//
//  Created by Frostjaw on 17/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import Foundation

struct Task {
  var id: Int
  var title: String
  var description: String
  var done: Int
  var deadline: Int
  var category: Category
  var priority: Priority
  var created: Int
}

extension Task: Decodable {
  enum CodingKeys: String, CodingKey {
    case id
    case title
    case description
    case done
    case deadline
    case category
    case priority
    case created
    
  }
  
  init(from: Decoder) throws {
    let values = try from.container(keyedBy: CodingKeys.self)
    self.id = try values.decode(Int.self, forKey: .id)
    self.title = try values.decode(String.self, forKey: .title)
    self.description = try values.decode(String.self, forKey: .description)
    self.done = try values.decode(Int.self, forKey: .done)
    self.deadline = try values.decode(Int.self, forKey: .deadline)
    self.created = try values.decode(Int.self, forKey: .created)
    self.category = try values.decode(Category.self, forKey: .category)
    self.priority = try values.decode(Priority.self, forKey: .priority)
    
  }
}
