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
    @State private var isShowingLaunchView = true
    
    var body: some Scene {
        WindowGroup {
            if isShowingLaunchView {
                LaunchView(showLaunchView: $isShowingLaunchView)
            } else {
                LoginView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
