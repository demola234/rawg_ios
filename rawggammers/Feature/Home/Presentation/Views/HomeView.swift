//
//  HomeView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var scrollAnimation: Bool = false
    @State private var showScrollToTopButton: Bool = false
    @Namespace private var namespace
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            NavigationStack {
                VStack(alignment: .leading, spacing: 0) {
                    HomeHeaderView(userDetails: authViewModel.userDetails ?? UsersDataEntity())
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 16) {
                            // searchBar
                            ScrollTabBarView(selectedTab: $homeViewModel.selectedTab)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                            content
                        }
                    }
                }
            }
        }
        .onAppear {
            withAnimation {
                scrollAnimation = true
            }
        }
    }
    
    private var searchBar: some View {
        HStack(alignment: .center, spacing: 8) { }
            .padding(.horizontal, 16)
            .padding(.vertical, 11)
            .frame(width: 396, height: 50, alignment: .leading)
            .background(Color.white)
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .inset(by: 0.5)
                    .stroke(Color(red: 0.75, green: 0.76, blue: 0.79), lineWidth: 1)
            )
    }
    
    private var content: some View {
        VStack(alignment: .leading) {
            
            sectionTitle(homeViewModel.scrollTitle)
            if !homeViewModel.isGamesLoading {
                horizontalScrollView(items: homeViewModel.games, id: \.id) { game in
                    GeometryReader { geometry in
                        NavigationLink(destination: GameDetailsView(gameId: game.slug ?? "").hideTabBar(true)) {
                            GamesCardView(gameData: game)
                                .rotation3DEffect(
                                    Angle(degrees: Double((geometry.frame(in: .global).minX - 30) / -20)),
                                    axis: (x: 0, y: 10, z: 0)
                                )
                                .frame(width: 210, height: 250)
                        }
                    }
                    .frame(width: 210, height: 270)
                }
            } else {
                
                ProgressView()
                
            }
            
            sectionTitle("Platforms")
            horizontalScrollView(items: homeViewModel.platforms?.results ?? [], id: \.id) { platform in
                NavigationLink(destination: GameDetailsView(gameId: platform.slug ?? "").hideTabBar(true)) {
                    PlatformCardDetails(platformDetails: platform)
                }
            }
            
            sectionTitle("Latest Games")
            verticalScrollView(items: homeViewModel.bestGames, id: \.id) { bestGame in
                NavigationLink(destination: GameDetailsView(gameId: bestGame.slug ?? "").hideTabBar(true)) {
                    LatestGamesCardView(gameDetails: bestGame)
                }
            }
            
            if homeViewModel.isGamesLoading {
                ProgressView()
                    .padding()
            } else {
                GeometryReader { geometry -> Color in
                    DispatchQueue.main.async {
                        if geometry.frame(in: .global).maxY < UIScreen.main.bounds.height {
                            homeViewModel.loadMoreGames()
                        }
                    }
                    return Color.clear
                }
                .frame(height: 50)
            }
        }
    }
    
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .customFont(CustomFont.orbitronSemiBold.copyWith(size: 20))
            .foregroundColor(.theme.primaryTextColor)
            .padding(.horizontal, 16)
            .padding(.top, 10)
    }
    
    private func horizontalScrollView<Item, Content: View>(items: [Item], id: KeyPath<Item, Int?>, @ViewBuilder content: @escaping (Item) -> Content) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(items, id: id) { item in
                    content(item)
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    private func horizontalScrollView<Item, Content: View>(items: [Item], id: KeyPath<Item, String>, @ViewBuilder content: @escaping (Item) -> Content) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(items, id: id) { item in
                    content(item)
                        .frame(width: 200, height: 220)
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 10)
    }
    
    private func verticalScrollView<Item, Content: View>(items: [Item], id: KeyPath<Item, Int?>, @ViewBuilder content: @escaping (Item) -> Content) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                ForEach(items, id: id) { item in
                    content(item)
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    private func verticalScrollView<Item, Content: View>(items: [Item], id: KeyPath<Item, String>, @ViewBuilder content: @escaping (Item) -> Content) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                ForEach(items, id: id) { item in
                    content(item)
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    private func scrollToTopButton(_ proxy: ScrollViewProxy) -> some View {
        VStack {
            Spacer()
            if showScrollToTopButton {
                Button(action: {
                    withAnimation {
                        proxy.scrollTo(0, anchor: .top)
                    }
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                        .padding()
                }
            }
        }
    }
}

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(dev.homeViewModel)
            .environmentObject(AuthenticationViewModel())
    }
}
