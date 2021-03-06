//
//  BackendService.swift
//  ios_lab2
//
//  Created by Frostjaw on 13/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import Alamofire

class BackendService {
  
  enum LocalConstants {
    static let BASE_URL = "http://practice.mobile.kreosoft.ru/api/"
    static let REGISTER_URL = "register"
    static let LOGIN_URL = "login"
    static let PRIORITIES_URL = "priorities"
    static let CATEGORIES_URL = "categories"
    static let TASKS_URL = "tasks"
    static let headers = [
      "Authorization": "Bearer \(UserDefaults.standard.string(forKey: GlobalConstants.tokenKey)!)"
    ]
    static let serializationErrorMessage = "serialization error"
    static let responseFromServerKey = "message"
    static let successMessage = "success"
  }
  
  func registerUser(email: String, name: String, password: String, completionHandler: @escaping (Result<TokenResult>) -> Void) {
    
    let parameters = [
      "email": email,
      "name": name,
      "password": password
    ]
    
    Alamofire.request(LocalConstants.BASE_URL + LocalConstants.REGISTER_URL, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
      switch response.result {
      case .success(let response):
        do {
          let payload = try JSONDecoder().decode(TokenResult.self, from: response)
          completionHandler(.success(payload))
        } catch _ {
          do {
            let json = try JSONSerialization.jsonObject(with: response, options: []) as? [String: Any]
            let message = json![LocalConstants.responseFromServerKey]!
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
            completionHandler(.failure(error))
          }
          catch {
            print(LocalConstants.serializationErrorMessage)
          }
          
        }
        
      case .failure(let error):
        completionHandler(.failure(error))
        
      }
      
    }
    
  }
  
  func loginUser(email: String, password: String, completionHandler: @escaping (Result<TokenResult>) -> Void) {
    
    let parameters = [
      "email": email,
      "password": password
    ]
    
    Alamofire.request(LocalConstants.BASE_URL + LocalConstants.LOGIN_URL, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
      switch response.result {
      case.success(let response):
        do {
          let payload = try JSONDecoder().decode(TokenResult.self, from: response)
          completionHandler(.success(payload))
        } catch _ {
          do {
            let json = try JSONSerialization.jsonObject(with: response, options: []) as? [String: Any]
            let message = json![LocalConstants.responseFromServerKey]!
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
            completionHandler(.failure(error))
          }
          catch {
            print(LocalConstants.serializationErrorMessage)
          }
          
        }
        
      case .failure(let error):
        completionHandler(.failure(error))
      }
      
    }
    
  }
  
  func getCategories(id: String, completionHandler: @escaping (Result<[Category]>) -> Void) {
    
    Alamofire.request(LocalConstants.BASE_URL + LocalConstants.CATEGORIES_URL, method: HTTPMethod.get, encoding: JSONEncoding.default, headers: LocalConstants.headers).responseData { response in
      switch response.result {
      case.success(let response):
        do {
          let payload = try JSONDecoder().decode([Category].self, from: response)
          completionHandler(.success(payload))
        } catch {
          print(error.localizedDescription)
          do {
            let json = try JSONSerialization.jsonObject(with: response, options: []) as? [String: Any]
            let message = json![LocalConstants.responseFromServerKey]!
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
            completionHandler(.failure(error))
          }
          catch {
            print(LocalConstants.serializationErrorMessage)
          }
          
        }
        
      case .failure(let error):
        completionHandler(.failure(error))
      }
    }
    
  }
  
  func postCategory(name: String, completionHandler: @escaping (Result<Category>) -> Void) {
    
    let parameters = [
      "name": name
    ]
    
    Alamofire.request(LocalConstants.BASE_URL + LocalConstants.CATEGORIES_URL, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: LocalConstants.headers).responseData { response in
      switch response.result {
      case.success(let response):
        do {
          let payload = try JSONDecoder().decode(Category.self, from: response)
          completionHandler(.success(payload))
        } catch _ {
          do {
            let json = try JSONSerialization.jsonObject(with: response, options: []) as? [String: Any]
            let message = json![LocalConstants.responseFromServerKey]!
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
            completionHandler(.failure(error))
          }
          catch {
            print(LocalConstants.serializationErrorMessage)
          }
          
        }
        
      case .failure(let error):
        completionHandler(.failure(error))
      }
      
    }
  }
  
  func getTasks(id: String, completionHandler: @escaping (Result<[Task]>) -> Void) {
    
    Alamofire.request(LocalConstants.BASE_URL + LocalConstants.TASKS_URL, method: HTTPMethod.get, encoding: JSONEncoding.default, headers: LocalConstants.headers).responseData { response in
      switch response.result {
      case.success(let response):
        do {
          let payload = try JSONDecoder().decode([Task].self, from: response)
          completionHandler(.success(payload))
        } catch {
          print(error.localizedDescription)
          do {
            let json = try JSONSerialization.jsonObject(with: response, options: []) as? [String: Any]
            let message = json![LocalConstants.responseFromServerKey]!
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
            completionHandler(.failure(error))
          }
          catch {
            print(LocalConstants.serializationErrorMessage)
          }
          
        }
        
      case .failure(let error):
        completionHandler(.failure(error))
      }
    }
    
  }
  
  func getPriorities(id: String, completionHandler: @escaping (Result<[Priority]>) -> Void) {
    
    Alamofire.request(LocalConstants.BASE_URL + LocalConstants.PRIORITIES_URL, method: HTTPMethod.get, encoding: JSONEncoding.default, headers: LocalConstants.headers).responseData { response in
      switch response.result {
      case.success(let response):
        do {
          let payload = try JSONDecoder().decode([Priority].self, from: response)
          completionHandler(.success(payload))
        } catch {
          print(error.localizedDescription)
          do {
            let json = try JSONSerialization.jsonObject(with: response, options: []) as? [String: Any]
            let message = json![LocalConstants.responseFromServerKey]!
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
            completionHandler(.failure(error))
          }
          catch {
            print(LocalConstants.serializationErrorMessage)
          }
          
        }
        
      case .failure(let error):
        completionHandler(.failure(error))
      }
    }
    
  }
  
  func patchTask(taskId: Int, title: String, description: String, done: Int, deadline: Int, categoryId: Int, priorityId: Int, completionHandler: @escaping (Result<Task>) -> Void) {
    
    let parameters = [
      "title": title,
      "description": description,
      "done": done,
      "deadline": deadline,
      "category_id": categoryId,
      "priority_id": priorityId
      ] as [String : Any]
    
    Alamofire.request(LocalConstants.BASE_URL + LocalConstants.TASKS_URL + "/\(taskId)", method: HTTPMethod.patch, parameters: parameters, encoding: JSONEncoding.default, headers: LocalConstants.headers).responseData { response in
      switch response.result {
      case.success(let response):
        do {
          let payload = try JSONDecoder().decode(Task.self, from: response)
          completionHandler(.success(payload))
        } catch _ {
          do {
            let json = try JSONSerialization.jsonObject(with: response, options: []) as? [String: Any]
            let message = json![LocalConstants.responseFromServerKey]!
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
            completionHandler(.failure(error))
          }
          catch {
            print(LocalConstants.serializationErrorMessage)
          }
          
        }
        
      case .failure(let error):
        completionHandler(.failure(error))
      }
      
    }
  }
  
  func postTask(title: String, description: String, done: Int, deadline: Int, categoryId: Int, priorityId: Int, completionHandler: @escaping (Result<Task>) -> Void) {
    
    let parameters = [
      "title": title,
      "description": description,
      "done": done,
      "deadline": deadline,
      "category_id": categoryId,
      "priority_id": priorityId
      ] as [String : Any]
    
    Alamofire.request(LocalConstants.BASE_URL + LocalConstants.TASKS_URL, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: LocalConstants.headers).responseData { response in
      switch response.result {
      case.success(let response):
        do {
          let payload = try JSONDecoder().decode(Task.self, from: response)
          completionHandler(.success(payload))
        } catch _ {
          do {
            let json = try JSONSerialization.jsonObject(with: response, options: []) as? [String: Any]
            let message = json![LocalConstants.responseFromServerKey]!
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
            completionHandler(.failure(error))
          }
          catch {
            print(LocalConstants.serializationErrorMessage)
          }
          
        }
        
      case .failure(let error):
        completionHandler(.failure(error))
      }
      
    }
  }
  
  func deleteTask(taskId: Int, completionHandler: @escaping (Result<String>) -> Void) {
    
    Alamofire.request(LocalConstants.BASE_URL + LocalConstants.TASKS_URL + "/\(taskId)", method: HTTPMethod.delete, encoding: JSONEncoding.default, headers: LocalConstants.headers).responseData { response in
      switch response.result {
      case.success(_):
        completionHandler(.success(LocalConstants.successMessage))
        
      case .failure(let error):
        completionHandler(.failure(error))
      }
      
    }
  }
  
  func isConnectedToInternet() -> Bool {
    return NetworkReachabilityManager()!.isReachable
  }
}
