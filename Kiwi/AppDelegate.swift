//
//  AppDelegate.swift
//  Kiwi
//
//  Created by Brandon Guerra on 1/28/20.
//  Copyright © 2020 Brandon Guerra. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    instantiateMainViewController()
    return true
  }
}

private extension AppDelegate {
    private func instantiateMainViewController() {
      let mainViewController = ViewController()
      let navigationConroller = UINavigationController(rootViewController: mainViewController)
      window = UIWindow(frame: UIScreen.main.bounds)
      window?.rootViewController = navigationConroller
      window?.makeKeyAndVisible()
    }
}


