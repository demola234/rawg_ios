//
//  rawggammersApp.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 20/07/2024.
//

import SwiftUI

@main
struct rawggammersApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject private var authViewModel = AuthenticationViewModel()
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var settingsViewModel = SettingsViewModel()
    @State private var isShowingLaunchView = true
    
    var body: some Scene {
        WindowGroup {
            if isShowingLaunchView {
                LaunchView(showLaunchView: $isShowingLaunchView)
            } else {
                if authViewModel.isLogged {
                    FancyTabView()
                        .environmentObject(authViewModel)
                } else {
                    LoginView()
                        .environmentObject(authViewModel)
                }
            }
        }
        .environmentObject(themeManager)
        .environmentObject(settingsViewModel)
        
    }
}
