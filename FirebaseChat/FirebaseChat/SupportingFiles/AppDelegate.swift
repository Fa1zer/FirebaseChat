//
//  AppDelegate.swift
//  FirebaseChat
//
//  Created by Artemiy Zuzin on 08.01.2022.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        IQKeyboardManager.shared.enable = true
        
        return true
    }

}

