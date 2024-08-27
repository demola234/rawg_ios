//
//  ProfileView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import SwiftUI

/// View for displaying and managing user profile settings.
///
/// This view includes options for changing the avatar, app icon, theme, and more. It also provides
/// access to various settings and allows users to log out of their account.
///
/// - Environment Objects:
///   - `authViewModel`: Manages authentication-related tasks and user sessions.
///   - `themeManager`: Manages the app's theme settings.
///   - `settingsViewModel`: Manages user profile settings and interactions.
/// - State:
///   - `appIconManager`: Manages the app icon selection.
///   - `offset`: Tracks the vertical offset for bottom sheet animations.
///   - `showBottomSheet`: Controls the visibility of the bottom sheet for app icon selection.
///   - `showBottomSheetThemeSheet`: Controls the visibility of the bottom sheet for theme selection.
///   - `showAboutSheet`: Controls the visibility of the bottom sheet for the about section.
///   - `showLogoutSheet`: Controls the visibility of the bottom sheet for logout confirmation.
///   - `showAvatarSheet`: Controls the visibility of the sheet for changing the user avatar.
struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @StateObject var appIconManager = AppIconManager()
    
    @State private var offset: CGFloat = 0
    @State private var showBottomSheet = false
    @State private var showBottomSheetThemeSheet = false
    @State private var showAboutSheet = false
    @State private var showLogoutSheet = false
    @State private var showAvatarSheet = false
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 10) {
                // Settings Header
                Text("Settings")
                    .customFont(CustomFont.orbitronSemiBold.copyWith(size: 20))
                    .foregroundColor(.theme.primaryTextColor)
                    .padding(.vertical, 10)
                
                // Personal Section
                SectionHeader(title: "Personal")
                AvatarSettingsView()
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showAvatarSheet.toggle()
                        }
                    }
                    .environmentObject(settingsViewModel)
                
                if (settingsViewModel.user?.authType == "email") {
                    SettingsCardView(title: "Change Password", subTitle: "Modify your account Password", icon: "tag_user")
                }
                
                // App Customization Section
                SectionHeader(title: "App Customization")
                
                // App Icon
                SettingsCardView(title: "Change App Icon", subTitle: "Select different app icons", icon: "emoji_happy")
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showBottomSheet.toggle()
                        }
                    }
                
                // Theme Selection
                SettingsCardView(title: "Change Theme", subTitle: "Switch between Light or Dark Mode", icon: themeManager.currentTheme == .light ? "moon" : "sun")
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showBottomSheetThemeSheet.toggle()
                        }
                    }
                
                // About Section
                SectionHeader(title: "About")
                SettingsCardView(title: "About the App", subTitle: "V.1.0.0", icon: "information")
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showAboutSheet.toggle()
                        }
                    }
                
                // Logout Section
                SectionHeader(title: "Logout")
                SettingsCardView(title: "Logout", background: Color.theme.error, textColor: Color.white, icon: "logout")
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showLogoutSheet.toggle()
                        }
                    }
                
                Spacer()
            }
            .padding(.horizontal, 15)
            
            // Bottom Sheet Overlay
            BottomSheetOverlay(show: $showBottomSheet, showThemeSheet: $showBottomSheetThemeSheet, showAboutUs: $showAboutSheet, showLogout: $showLogoutSheet)
            
            // Theme Selection Sheet
            if showBottomSheetThemeSheet {
                BottomSheetView(show: $showBottomSheetThemeSheet, offset: $offset, height: 300) {
                    ThemeSelectionView()
                        .environmentObject(themeManager)
                }
            }
            
            // App Icon Selection Sheet
            if showBottomSheet {
                BottomSheetView(show: $showBottomSheet, offset: $offset, height: 300) {
                    AppIconSelectionView()
                        .environmentObject(appIconManager)
                }
            }
            
            // About Us Sheet
            if showAboutSheet {
                BottomSheetView(show: $showAboutSheet, offset: $offset, height: 300) {
                    AboutUsView()
                }
            }
            
            // Logout Confirmation Sheet
            if showLogoutSheet {
                BottomSheetView(show: $showLogoutSheet, offset: $offset, height: 200) {
                    LogoutConfirmationView(showLogoutSheet: $showLogoutSheet)
                        .environmentObject(authViewModel)
                }
            }
            
        }
        .sheet (isPresented: $showAvatarSheet) {
            ChangeUserAvatar(showChangeAvatar: $showAvatarSheet)
                .environmentObject(settingsViewModel)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthenticationViewModel())
        .environmentObject(ThemeManager())
        .environmentObject(SettingsViewModel())
}

/// View for displaying a section header.
///
/// - Parameter title: The title of the section.
struct SectionHeader: View {
    var title: String
    
    var body: some View {
        Text(title)
            .customFont(CustomFont.orbitronSemiBold.copyWith(size: 12))
            .foregroundColor(.theme.primaryTextColor)
            .padding(.vertical, 10)
    }
}

/// View for selecting the app theme.
///
/// Allows users to choose between Light, Dark, and System themes.
struct ThemeSelectionView: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        VStack {
            Text("Select Theme")
                .customFont(CustomFont.orbitronMedium.copyWith(size: 15))
                .foregroundColor(.theme.primaryTextColor)
            
            Spacer()
            
            HStack(spacing: 40) {
                Button(action: {
                    withAnimation(.spring()) {
                        themeManager.switchTheme(to: .light)
                    }
                }) {
                    ThemeButtonSelection(mode: Theme.light, RightBg: Color.theme.accentTextColor, RightFg: Color.white, BottomBg: Color.theme.accentTextColor, BottomFg: Color.white)
                }
                
                Button(action: {
                    withAnimation(.spring()) {
                        themeManager.switchTheme(to: .dark)
                    }
                }) {
                    ThemeButtonSelection(mode: Theme.dark, RightBg: Color.theme.accentTextColor, RightFg: Color.black, BottomBg: Color.black, BottomFg: Color.theme.accentTextColor)
                }
                    
                Button(action: {
                    withAnimation(.spring()) {
                        themeManager.switchTheme(to: .system)
                    }
                }) {
                    ZStack {
                        ThemeButtonSelection(mode: Theme.system, RightBg: Color.theme.accentTextColor, RightFg: Color.white, BottomBg: Color.theme.accentTextColor, BottomFg: Color.white)
                        
                        ThemeButtonSelection(mode: Theme.system, RightBg: Color.theme.accentTextColor, RightFg: Color.black, BottomBg: Color.black, BottomFg: Color.theme.accentTextColor)
                            .mask {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 50, height: 200)
                                    .offset(x: -24)
                            }
                    }
                    
                }
            }
            
            Spacer()
        }
    }
}

/// View for selecting the app icon.
///
/// Displays a list of available app icons and allows users to select one.
struct AppIconSelectionView: View {
    @EnvironmentObject var appIconManager: AppIconManager
    
    var body: some View {
        VStack {
            Text("Select App Icon")
                .customFont(CustomFont.orbitronMedium.copyWith(size: 15))
                .foregroundColor(.theme.primaryTextColor)
            
            Spacer()
            
            HStack(alignment: .center) {
                ForEach(appIconManager.icons.indices, id: \.self) { index in
                    IconRow(icon: appIconManager.icons[index])
                        .onTapGesture {
                            withAnimation {
                                appIconManager.iconIndex = index
                                changeAppIcon(to: appIconManager.icons[index].iconName)
                            }
                        }
                }
            }
            
            Spacer()
        }
    }
    
    /// Changes the app icon to the specified icon name.
    ///
    /// - Parameter iconName: The name of the icon to set.
    func changeAppIcon(to iconName: String?) {
        guard UIApplication.shared.supportsAlternateIcons else {
            print("App does not support alternate icons")
            return
        }
        
        UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

/// View for displaying an overlay behind the bottom sheets.
///
/// Provides a dimmed background and dismisses all sheets when tapped.
struct BottomSheetOverlay: View {
    @Binding var show: Bool
    @Binding var showThemeSheet: Bool
    @Binding var showAboutUs: Bool
    @Binding var showLogout: Bool
    
    var body: some View {
        if show || showThemeSheet || showLogout || showAboutUs {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        show = false
                        showThemeSheet = false
                        showLogout = false
                        showAboutUs = false
                    }
                }
        }
    }
}
