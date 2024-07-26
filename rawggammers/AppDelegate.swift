//
//  AppDelegate.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 25/07/2024.
//

import UIKit
import SwiftUI
import Firebase

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let launchView = LaunchView(showLaunchView: .constant(true))
        let loginView = LoginView().environmentObject(AuthenticationViewModel())
        
        window?.rootViewController = UIHostingController(rootView: launchView)
        window?.makeKeyAndVisible()
        return true
    }
}