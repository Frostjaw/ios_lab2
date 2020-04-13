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
  }
  
  func registerUser(email: String, name: String, password: String) {
    
    let parameters = [
      "email": email,
      "name": name,
      "password": password
    ]
    
    Alamofire.request(Constants.BASE_URL + Constants.REGISTER_URL, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
      switch response.result {
      case .success(let value as [String: Any]):
        //completion(.success(value))
        print("Request completed, response: \(value)")
        
      case .failure(let error):
        //completion(.failure(error))
        print ("Request failed with error: \(error)")
      default:
        fatalError("received non-dictionary JSON response")
      }
      
    }
    
  }
  
  func loginUser(email: String, password: String) {
    let parameters = [
      "email": email,
      "password": password
    ]
    
    Alamofire.request(Constants.BASE_URL + Constants.LOGIN_URL, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
      switch response.result {
      case .success(let value as [String: Any]):
        //completion(.success(value))
        print("Request completed, response: \(value)")
        
      case .failure(let error):
        //completion(.failure(error))
        print ("Request failed with error: \(error)")
        
      default:
        fatalError("received non-dictionary JSON response")
      }
      
    }
    
  }
}
