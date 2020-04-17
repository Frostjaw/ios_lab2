//
//  TaskModel.swift
//  ios_lab2
//
//  Created by Frostjaw on 17/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import Foundation

class TaskModel {
  
  var tasks: [Task]?
  
  weak var delegate: TaskModelDelegate?
  
  func requestData() {
    
    //test
    var categories = [Category]()
    
    let importantPriority = Priority(id: 1, name: "important", color: "#EF7004D")
    let task1 = Task(id: 1, title: "Test title 1", description: "Test description 1", done: 0, deadline: 123, priority: importantPriority, created: 100)
    let task2 = Task(id: 2, title: "Test title 2", description: "Test description 2", done: 0, deadline: 123, priority: importantPriority, created: 100)
    let task3 = Task(id: 3, title: "Test title 3", description: "Test description 3", done: 0, deadline: 123, priority: importantPriority, created: 100)
    let workCategory = Category(id: 1, name: "work", tasks: [task1, task2])
    let studyCategory = Category(id: 2, name: "study", tasks: [task3])
    
    categories.append(workCategory)
    categories.append(studyCategory)
    
    // receive and parse
    //let data = "data from whatever"
    
    delegate?.didReceiveDataUpdate(data: categories)
  }
}

protocol TaskModelDelegate: class {
  
  func didReceiveDataUpdate(data: [Category])
}
