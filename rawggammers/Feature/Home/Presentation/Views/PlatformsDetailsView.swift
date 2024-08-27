//
//  PlatformsDetailsView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 24/08/2024.
//

import SwiftUI

/// A view that displays details of a selected platform, including games available on that platform.
struct PlatformsDetailsView: View {
    /// Environment variable to handle view dismissal.
    @Environment(\.dismiss) var dismiss
    
    /// Environment object to manage platform-related data and loading state.
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    /// A binding to the selected platform's details.
    @Binding var platform: PlatformResult?
    
    /// State variable to manage the display of the `GameDetailsView`.
    @State private var showDetailsView = false
    
    /// State variable to hold the selected game's details.
    @State private var gameDetails: ResultData?
    
    /// State variable to hide the header when scrolling.
    @State private var hideHeader = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color for the view.
                Color.theme.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ZStack {
                        // Background image for the platform.
                        if let imageUrl = URL(string: platform?.platforms?.first?.imageBackground ?? "") {
                            NetworkImageView(imageURL: imageUrl)
                                .scaledToFill()
                                .frame(height: 100)
                                .clipped()
                                .overlay(Color.black.opacity(0.3))
                                .blur(radius: 2)
                                .opacity(hideHeader ? 0 : 1)
                                .animation(.easeInOut(duration: 0.3), value: hideHeader)
                            
                            HStack {
                                // Back button to dismiss the view.
                                Button(action: {
                                    HepticManager().prepareSoft()
                                    dismiss()
                                }) {
                                    HStack(alignment: .center, spacing: 0) {
                                        Image(systemName: "chevron.left")
                                            .font(.system(size: 24, weight: .light))
                                            .foregroundColor(Color.theme.primaryTextColor)
                                            .padding(8)
                                    }
                                    .padding(8)
                                    .frame(width: 50, height: 50, alignment: .center)
                                    .background(Color.theme.background)
                                    .clipShape(Circle())
                                }
                                
                                Spacer()
                                
                                // Displays the platform's name if the header is not hidden.
                                if !hideHeader {
                                    Text("\(platform?.name ?? "")")
                                        .customFont(CustomFont.orbitronSemiBold.copyWith(size: 20))
                                        .foregroundColor(Color.white)
                                        .padding(.vertical, 10)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 30)
                        }
                    }
                    .ignoresSafeArea()
                    
                    // List of games available on the platform.
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 20) {
                            ForEach(homeViewModel.platformGames, id: \.id) { platformGames in
                                LatestGamesCardView(gameDetails: platformGames)
                                    .onTapGesture {
                                        segue(selectedDetails: platformGames)
                                    }
                            }
                        }
                        .padding(.horizontal, 16)
                        // Tracks scroll offset to hide or show the header.
                        .background(GeometryReader { geo in
                            Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: geo.frame(in: .global).minY)
                        })
                    }
                }
                .onAppear {
                    // Fetches the games available for the selected platform.
                    homeViewModel.getGamesByPlatform(platform: platform?.id ?? 0)
                }
                // Adjusts header visibility based on scroll offset.
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    withAnimation {
                        hideHeader = value < -50
                    }
                }
            }
        }
        // Navigates to the `GameDetailsView` when a game is selected.
        .navigationDestination(isPresented: $showDetailsView) {
            if gameDetails != nil {
                GameDetailsView(gameDetails: $gameDetails)
            }
        }
        .navigationBarHidden(true)
    }
    
    /// Segues to the game details view with the selected game's data.
    /// - Parameter selectedDetails: The selected game's data to be passed to the details view.
    private func segue(selectedDetails: ResultData) {
        gameDetails = selectedDetails
        showDetailsView.toggle()
    }
}

/// Preference key to track scroll offset.
struct ScrollOffsetPreferenceKeys: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct PlatformsDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PlatformsDetailsView(platform: .constant(dev.platform.results?.first))
            .environmentObject(HomeViewModel())
    }
}
