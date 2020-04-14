//
//  AppDelegate.swift
//  ios_lab2
//
//  Created by Frostjaw on 09/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    let viewController = LogInViewController()
    
    //let navController = UINavigationController(rootViewController: viewController)
    
    self.window?.rootViewController = viewController
    //self.window?.rootViewController = navController
    self.window?.makeKeyAndVisible()
    
    return true
  }
  
}

