//
//  ProfileView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject var appIconManager = AppIconManager()
    
    @State private var offset: CGFloat = 0
    @State private var showBottomSheet = false
    @State private var showBottomSheetThemeSheet = false
    @State private var showAboutSheet = false
    @State private var showLogoutSheet = false
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 10) {
                // Settings Header
                SectionHeader(title: "Settings")
                
                // Personal Section
                SectionHeader(title: "Personal")
                AvatarSettingsView()
                SettingsCardView(title: "Change Password", subTitle: "Modify your account Password", icon: "tag_user")
                
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
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthenticationViewModel())
        .environmentObject(ThemeManager())
}

// Section Header View
struct SectionHeader: View {
    var title: String
    
    var body: some View {
        Text(title)
            .customFont(CustomFont.orbitronSemiBold.copyWith(size: 12))
            .foregroundColor(.theme.primaryTextColor)
            .padding(.vertical, 10)
    }
}

// Theme Selection View
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

// App Icon Selection View
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
    
    // Change App Icon Function
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

// Bottom Sheet Overlay View
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
