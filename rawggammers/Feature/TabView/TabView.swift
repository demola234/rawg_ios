//
//  FancyTabView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import SwiftUI

/// A custom tab view that provides navigation between different screens with a styled tab bar.
///
/// This view contains a `TabView` with four tabs, each corresponding to a different view: `HomeView`, `SearchView`, `FavoriteScreen`, and `ProfileView`.
/// It also includes a custom tab bar (`CustomTabBar`) that provides a visually styled navigation bar with icons and titles.
/// The tab bar's appearance and selected state are customized based on the current selected tab and user details.
///
/// - Important: Ensure to provide the necessary `EnvironmentObject` instances for `FavoriteViewModel`, `SearchViewModel`, `HomeViewModel`, and `SettingsViewModel` in the view hierarchy.
///
/// - Note: This view uses a `VisualEffectView` for a blurred background effect and adjusts its layout based on the safe area.
struct FancyTabView: View {
    @Environment(\.hideTabBar) var hideTabBar
    @StateObject var authViewModel = AuthenticationViewModel()

    @State private var selectedTab = 0
    let tabBarImageNames = ["home", "search", "favorite", "person.fill"]
    let tabBarTitles = ["Home", "Search", "Favourites", "Profile"]

    var body: some View {
        ZStack {
            // Main TabView for switching between views
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)

                SearchView()
                    .tag(1)

                FavoriteScreen()
                    .tag(2)

                ProfileView()
                    .tag(3)
            }
            .edgesIgnoringSafeArea(.all)

            // Custom Tab Bar
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab,
                             userDetails: authViewModel.userDetails ?? UsersDataEntity(),
                             tabBarImageNames: tabBarImageNames,
                             tabBarTitles: tabBarTitles)
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .background(
                    ZStack {
                        VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
                    }
                )
                .edgesIgnoringSafeArea(.all)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .environmentObject(FavoriteViewModel())
        .environmentObject(SearchViewModel())
        .environmentObject(HomeViewModel())
    }
}

/// A custom tab bar component used within `FancyTabView`.
///
/// This component displays a row of buttons corresponding to the tabs in `FancyTabView`. Each button consists of an icon and a title.
/// The selected tab is highlighted with a gold color, and the profile icon can show a user's photo or a placeholder image.
/// The tab bar also includes a custom appearance for the selected state and handles user interaction with haptic feedback.
///
/// - Parameters:
///   - selectedTab: A binding to the currently selected tab index.
///   - settingsViewModel: An environment object providing user settings and profile information.
///   - tabBarImageNames: An array of image names for the tab icons.
///   - tabBarTitles: An array of titles for the tabs.
struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    var userDetails = UsersDataEntity()
    let tabBarImageNames: [String]
    let tabBarTitles: [String]

    var body: some View {
        HStack {
            ForEach(0..<tabBarImageNames.count, id: \.self) { index in
                Spacer()
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    withAnimation {
                        selectedTab = index
                    }
                }) {
                    VStack {
                        if index != 3 {
                            Image(tabBarImageNames[index])
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(selectedTab == index ? .theme.goldColor : .gray)
                                .frame(width: 18, height: 18)
                                .scaleEffect(selectedTab == index ? 1.0 : 1.0)
                        } else {
                            if (settingsViewModel.user?.photoUrl.isEmpty ?? true) {
                                Image("Spiderman1")
                                    .frame(width: 27, height: 27)
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                    .padding(.all, 1)
                                    .overlay {
                                        selectedTab == index ? Circle().stroke(Color.theme.goldColor, lineWidth: 1) : nil
                                    }
                            } else if settingsViewModel.isUpdating {
                                ProgressView()
                                    .frame(width: 27, height: 27)
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                    .padding(.all, 1)
                                    .overlay {
                                        selectedTab == index ? Circle().stroke(Color.theme.goldColor, lineWidth: 1) : nil
                                    }
                            } else {
                                NetworkImageView(imageURL: URL(string: settingsViewModel.user?.photoUrl ?? "")!)
                                    .frame(width: 27, height: 27)
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                    .padding(.all, 1)
                                    .overlay {
                                        selectedTab == index ? Circle().stroke(Color.theme.goldColor, lineWidth: 1) : nil
                                    }
                            }
                        }
                        Text(tabBarTitles[index])
                            .font(.caption)
                            .foregroundColor(selectedTab == index ? .theme.goldColor : .gray)
                    }
                }
                Spacer()
            }
        }
    }
}

// Preview for SwiftUI
#Preview {
    FancyTabView()
        .environmentObject(FavoriteViewModel())
        .environmentObject(SearchViewModel())
        .environmentObject(HomeViewModel())
        .environmentObject(SettingsViewModel())
}
