//
//  AppDelegate.swift
//  SideMenuExample
//
//  Created by Phuc Nguyen on 2024-09-24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainVC = MainViewController()
        window?.backgroundColor = .systemBackground
        window?.rootViewController = mainVC
        window?.makeKeyAndVisible()
        
        return true
    }
}

