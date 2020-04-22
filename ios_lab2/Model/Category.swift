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

}

