//
//  HomeView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import SwiftUI

/// The main view that displays the home screen of the app.
///
/// `HomeView` is responsible for displaying a variety of content on the home screen, including a header, game sections, platform cards, and more. It uses various state variables to manage the UI and user interactions.

struct HomeView: View {
    /// The view model responsible for managing the home view's data and state.
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    /// The view model responsible for handling authentication-related tasks.
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    /// State variable to control scroll animation.
    @State private var scrollAnimation: Bool = false
    
    /// State variable to control the visibility of the scroll-to-top button.
    @State private var showScrollToTopButton: Bool = false
    
    /// State variable to hold the selected game details for navigation.
    @State private var selectedDetails: ResultData? = nil
    
    /// State variable to hold the selected platform details for navigation.
    @State private var selectedPlatform: PlatformResult? = nil
    
    /// State variable to control the visibility of the details view.
    @State private var showDetailsView = false
    
    /// State variable to control the visibility of the platform view.
    @State private var showPlatform = false
    
    /// Namespace used for matched geometry effects.
    @Namespace private var namespace
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    // Header view displaying user details and other information.
                    HomeHeaderView(userDetails: authViewModel.userDetails ?? UsersDataEntity())
                    
                    // Main content of the home view.
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 16) {
                            // Scroll tab bar for navigating different sections.
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
    
    /// The main content of the `HomeView` including sections for games, platforms, and latest games.
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
    
    /// Handles the navigation to the game details view.
    /// - Parameter gameDetails: The details of the selected game.
    private func segue(gameDetails: ResultData) {
        HepticManager().impact(style: .medium)
        selectedDetails = gameDetails
        showDetailsView.toggle()
    }
    
    /// Handles the navigation to the platform details view.
    /// - Parameter platform: The details of the selected platform.
    private func seguePlatform(platform: PlatformResult) {
        HepticManager().impact(style: .medium)
        selectedPlatform = platform
        showPlatform.toggle()
    }
    
    /// Creates a section title view with the specified title.
    /// - Parameter title: The title of the section.
    /// - Returns: A `Text` view with custom font and styling.
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .customFont(CustomFont.orbitronSemiBold.copyWith(size: 20))
            .foregroundColor(.theme.primaryTextColor)
            .padding(.horizontal, 16)
            .padding(.top, 10)
    }
    
    /// Creates a horizontal scroll view for displaying a list of items.
    /// - Parameters:
    ///   - items: The list of items to display.
    ///   - id: The key path to the item's identifier.
    ///   - content: A view builder for creating the view for each item.
    /// - Returns: A `ScrollView` containing horizontally scrollable items.
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
    
    /// Creates a horizontal scroll view for displaying a list of items with a string identifier.
    /// - Parameters:
    ///   - items: The list of items to display.
    ///   - id: The key path to the item's identifier.
    ///   - content: A view builder for creating the view for each item.
    /// - Returns: A `ScrollView` containing horizontally scrollable items.
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
    
    /// Creates a vertical scroll view for displaying a list of items.
    /// - Parameters:
    ///   - items: The list of items to display.
    ///   - id: The key path to the item's identifier.
    ///   - content: A view builder for creating the view for each item.
    /// - Returns: A `ScrollView` containing vertically scrollable items.
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
    
    /// Creates a vertical scroll view for displaying a list of items with a string identifier.
    /// - Parameters:
    ///   - items: The list of items to display.
    ///   - id: The key path to the item's identifier.
    ///   - content: A view builder for creating the view for each item.
    /// - Returns: A `ScrollView` containing vertically scrollable items.
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
    
    /// Creates a button for scrolling to the top of the view.
    /// - Parameter proxy: The `ScrollViewProxy` used for scrolling.
    /// - Returns: A `Button` that scrolls to the top when tapped.
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

/// A preference key to track the scroll view offset.
///
/// Used to determine when to show or hide the scroll-to-top button.
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
