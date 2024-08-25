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
    @State private var showChangeAvatar = false
    @State private var showName = false
    
    var body: some Scene {
        WindowGroup {
            if isShowingLaunchView {
                LaunchView(showLaunchView: $isShowingLaunchView)
            } else {
                if authViewModel.isLogged {
                    FancyTabView()
                        .environmentObject(authViewModel)
                        .onAppear {
                            checkForAvatar()
                            checkForName()
                        }
                        .sheet(isPresented: $showChangeAvatar) {
                            ChangeUserAvatar(showChangeAvatar: $showChangeAvatar)
                                .environmentObject(settingsViewModel)
                        }
                        .sheet(isPresented: $showName, content: {
                            CreateUsernameView()
                                .environmentObject(settingsViewModel)
                        })
                } else {
                    LoginView()
                        .environmentObject(authViewModel)
                }
            }
        }
        .environmentObject(themeManager)
        .environmentObject(settingsViewModel)
    }
    
    private func checkForAvatar() {
        if ((settingsViewModel.user?.photoUrl) == nil) {
            showChangeAvatar = true
        }
    }
    
    private func checkForName() {
        if (settingsViewModel.user?.name == nil) {
            showName = true
        }
    }
}
