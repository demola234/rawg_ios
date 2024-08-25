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
    @State private var selectedDetails: ResultData? = nil
    @State private var selectedPlatform: PlatformResult? = nil
    @State private var showDetailsView = false
    @State private var showPlatform = false
    @Namespace private var namespace
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea() 
                VStack(alignment: .leading, spacing: 0) {
                    HomeHeaderView(userDetails: authViewModel.userDetails ?? UsersDataEntity())
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 16) {
                            ScrollTabBarView(selectedTab: $homeViewModel.selectedTab)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                            content
                        }
                    }
                }
                .navigationDestination(isPresented: $showDetailsView) {
                    if selectedDetails != nil {
                        GameDetailsView(gameDetails: $selectedDetails)
                    }
                }
                .navigationDestination(isPresented: $showPlatform) {
                    if selectedPlatform != nil {
                        PlatformsDetailsView(platform: $selectedPlatform)
                    }
                }
            }
        }
        .background(Color.theme.background)
        .onAppear {
            withAnimation {
                scrollAnimation = true
            }
        }
    }
    
    private var content: some View {
        VStack(alignment: .leading) {
            sectionTitle(homeViewModel.scrollTitle)
            if !homeViewModel.isGamesLoading {
                horizontalScrollView(items: homeViewModel.games, id: \.id) { game in
                    GeometryReader { geometry in
                        GamesCardView(gameData: game)
                            .rotation3DEffect(
                                Angle(degrees: Double((geometry.frame(in: .global).minX - 30) / -20)),
                                axis: (x: 0, y: 10, z: 0)
                            )
                            .frame(width: 210, height: 250)
                            .onTapGesture {
                                segue(gameDetails: game)
                            }
                    }
                    .frame(width: 210, height: 270)
                }
            } else {
                ProgressView()
            }
            
            sectionTitle("Platforms")
            horizontalScrollView(items: homeViewModel.platforms?.results ?? [], id: \.id) { platform in
                PlatformCardDetails(platformDetails: platform)
                    .onTapGesture {
                        seguePlatform(platform: platform)
                    }
            }
            
            sectionTitle("Latest Games")
            verticalScrollView(items: homeViewModel.bestGames, id: \.id) { bestGame in
                LatestGamesCardView(gameDetails: bestGame)
                    .onTapGesture {
                        segue(gameDetails: bestGame)
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
    
    private func segue(gameDetails: ResultData) {
        HepticManager().impact(style: .medium)
        selectedDetails = gameDetails
        showDetailsView.toggle()
    }
    
    private func seguePlatform(platform: PlatformResult) {
        HepticManager().impact(style: .medium)
        selectedPlatform = platform
        showPlatform.toggle()
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
