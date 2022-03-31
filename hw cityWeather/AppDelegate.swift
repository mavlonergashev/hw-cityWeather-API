//
//  AppDelegate.swift
//  hw cityWeather
//
//  Created by Mavlon on 18/03/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        window?.rootViewController = MainVC(nibName: "MainVC", bundle: nil)
        window?.makeKeyAndVisible()
        
        return true
    }

}

