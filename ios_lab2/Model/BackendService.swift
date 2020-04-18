//
//  BackendService.swift
//  ios_lab2
//
//  Created by Frostjaw on 13/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import Alamofire

class BackendService {
  
  enum Constants {
    static let BASE_URL = "http://practice.mobile.kreosoft.ru/api/"
    static let REGISTER_URL = "register"
    static let LOGIN_URL = "login"
    static let PRIORITIES_URL = "priorities"
    static let CATEGORIES_URL = "categories"
    static let TASKS_URL = "tasks"
  }
  
  func registerUser(email: String, name: String, password: String, completionHandler: @escaping (Result<UserResult>) -> Void) {
    
    let parameters = [
      "email": email,
      "name": name,
      "password": password
    ]
    
    Alamofire.request(Constants.BASE_URL + Constants.REGISTER_URL, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
      switch response.result {
      case .success(let response):
        do {
          let payload = try JSONDecoder().decode(UserResult.self, from: response)
          completionHandler(.success(payload))
        } catch _ {
          do {
            let json = try JSONSerialization.jsonObject(with: response, options: []) as? [String: Any]
            let message = json!["message"]!
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
            completionHandler(.failure(error))
          }
          catch {
            print("Serialization error")
          }
          
        }
        
      case .failure(let error):
        completionHandler(.failure(error))
        
      }
      
    }
    
  }
  
  func loginUser(email: String, password: String, completionHandler: @escaping (Result<UserResult>) -> Void) {
    
    let parameters = [
      "email": email,
      "password": password
    ]
    
    Alamofire.request(Constants.BASE_URL + Constants.LOGIN_URL, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
      switch response.result {
      case.success(let response):
        do {
          let payload = try JSONDecoder().decode(UserResult.self, from: response)
          completionHandler(.success(payload))
        } catch _ {
          do {
            let json = try JSONSerialization.jsonObject(with: response, options: []) as? [String: Any]
            let message = json!["message"]!
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
            completionHandler(.failure(error))
          }
          catch {
            print("Serialization error")
          }
          
        }
        
      case .failure(let error):
        completionHandler(.failure(error))
      }
      
    }
    
  }
  
  func requestCategories(id: String, completionHandler: @escaping (Result<[Category]>) -> Void) {
      let headers = [
        "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "token")!)"
      ]
      
      Alamofire.request(Constants.BASE_URL + Constants.CATEGORIES_URL, method: HTTPMethod.get, encoding: JSONEncoding.default, headers: headers).responseData { response in
        switch response.result {
        case.success(let response):
          do {
            let payload = try JSONDecoder().decode([Category].self, from: response)
            completionHandler(.success(payload))
          } catch {
            print(error.localizedDescription)
  //          do {
  //            let json = try JSONSerialization.jsonObject(with: response, options: []) as? [String: Any]
  //            let message = json!["message"]!
  //            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
  //            completionHandler(.failure(error))
  //          }
  //          catch {
  //            print("Serialization error")
  //          }
            
          }
          
        case .failure(let error):
          completionHandler(.failure(error))
        }
      }
      
    }
  
  func requestTasks(id: String, completionHandler: @escaping (Result<[Task]>) -> Void) {
    let headers = [
      "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "token")!)"
    ]
    
    Alamofire.request(Constants.BASE_URL + Constants.TASKS_URL, method: HTTPMethod.get, encoding: JSONEncoding.default, headers: headers).responseData { response in
      switch response.result {
      case.success(let response):
        do {
          let payload = try JSONDecoder().decode([Task].self, from: response)
          completionHandler(.success(payload))
        } catch {
          print(error.localizedDescription)
//          do {
//            let json = try JSONSerialization.jsonObject(with: response, options: []) as? [String: Any]
//            let message = json!["message"]!
//            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
//            completionHandler(.failure(error))
//          }
//          catch {
//            print("Serialization error")
//          }
          
        }
        
      case .failure(let error):
        completionHandler(.failure(error))
      }
    }
    
  }
  
  func isConnectedToInternet() -> Bool {
    return NetworkReachabilityManager()!.isReachable
  }
}
