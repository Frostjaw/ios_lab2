//
//  AppDelegate.swift
//  ios_lab2
//
//  Created by Frostjaw on 09/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    IQKeyboardManager.shared.enable = true
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    
    if UserDefaults.standard.string(forKey: "token") == nil {
      let viewController = LogInViewController()
      self.window?.rootViewController = viewController
    } else {
      let mainViewController = MainViewController()
      let navController = UINavigationController(rootViewController: mainViewController)
      self.window?.rootViewController = navController
    }
    
    self.window?.makeKeyAndVisible()
    
    return true
  }
  
}

