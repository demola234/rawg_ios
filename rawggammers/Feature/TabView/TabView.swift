//
//  FancyTabView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import SwiftUI
struct FancyTabView: View {
    @Environment(\.hideTabBar) var hideTabBar
    @StateObject var authViewModel = AuthenticationViewModel()

    @State private var selectedTab = 0
    let tabBarImageNames = ["home", "search", "favorite", "person.fill"]
    let tabBarTitles = ["Home", "Search", "Favourites", "Profile"]

    var body: some View {
        ZStack {
            // TabView to manage the views
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
                    HepticManager().selection()
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
                            } 
                            else if(settingsViewModel.isUpdating) {
                                ProgressView()
                                    .frame(width: 27, height: 27)
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                    .padding(.all, 1)
                                    .overlay {
                                        selectedTab == index ? Circle().stroke(Color.theme.goldColor, lineWidth: 1) : nil
                                    }
                            }
                            else {
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
