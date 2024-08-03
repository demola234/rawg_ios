//
//  FancyTabView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import SwiftUI

struct FancyTabView: View {
    @Environment(\.hideTabBar) var hideTabBar
    @ObservedObject var authViewModel = AuthenticationViewModel()

    @State private var selectedTab = 0
    let tabBarImageNames = ["home", "search", "favorite", "person.fill"]
    let tabBarTitles = ["Home", "Search", "Favourites", "Profile"]


    var body: some View {
        VStack {
            ZStack {
                switch selectedTab {
                case 0:
                    HomeView()
                        .environmentObject(HomeViewModel())
                case 1:
                    SearchView()
                case 2:
                    FavoriteScreen()
                        .environmentObject(FavoriteViewModel())
                case 3:
                    ProfileView()
                       
                default:
                    HomeView()
                }
            }
            Spacer()
            CustomTabBar(selectedTab: $selectedTab, userDetails: authViewModel.userDetails ?? UsersDataEntity(), tabBarImageNames: tabBarImageNames, tabBarTitles: tabBarTitles)
                .frame(height: 80)
                .background(Color.theme.background.opacity(0.2))
            
        }
        .edgesIgnoringSafeArea(.bottom)
        
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
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
                                .scaleEffect(selectedTab == index ? 1.2 : 1.0)
                        } else {
                            
                            if let imageUrl = URL(string: userDetails.profileImageURL) {
                                NetworkImageView(imageURL: imageUrl)
                                    .frame(width: 27, height: 27)
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                    .padding(.all, 1)
                                    .overlay{
                                        selectedTab == index ? Circle().stroke(Color.theme.goldColor, lineWidth: 1) : nil}
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

#Preview {
    FancyTabView()
}
