//
//  TaskModel.swift
//  ios_lab2
//
//  Created by Frostjaw on 17/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import Foundation

class TaskModel {
  
  var categories = [Category]()
  weak var delegate: TaskModelDelegate?
  var backendService = BackendService()
  
  func requestData(id: String) {
    
    backendService.requestCategories(id: id) { result in
      switch result {
      case .failure(let error):
        print(error.localizedDescription)
        
      case .success(let response):
        self.categories = response
        self.requestTasks(id: id)
      }
    }
    
  }
  
  func requestTasks(id: String) {
    
    backendService.requestTasks(id: id) { result in
      switch result {
      case .failure(let error):
        print(error.localizedDescription)
        
      case .success(let response):
        let tasks = response
        for task in tasks {
          for (index, _) in self.categories.enumerated() {
            if task.category.id == self.categories[index].id {
              if self.categories[index].tasks == nil {
                self.categories[index].tasks = [Task]()
              }
              self.categories[index].tasks?.append(task)
            }
          }
        }
        
        for (index, _) in self.categories.enumerated().reversed() {
          if self.categories[index].tasks == nil {
            self.categories.remove(at: index)
          }
        }
        
        self.delegate?.didReceiveDataUpdate(data: self.categories)
      }
    }
    
  }
}

protocol TaskModelDelegate: class {
  
  func didReceiveDataUpdate(data: [Category])
}
