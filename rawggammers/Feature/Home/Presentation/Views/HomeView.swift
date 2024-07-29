//
//  HomeView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var scrollAnimation: Bool = false
    @State private var showScrollToTopButton: Bool = false
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            NavigationView {
                VStack(alignment: .leading, spacing: 0) {
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(spacing: 16) {
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
                                
                                ScrollTabBarView()
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                
                                VStack(alignment: .leading) {
                                    Text("New and Trending")
                                        .font(
                                            Font.custom("Orbitron", size: 20)
                                                .weight(.medium)
                                        )
                                        .foregroundColor(Color(red: 0.07, green: 0.07, blue: 0.09))
                                        .padding(.horizontal, 16)
                                        .padding(.top, 10)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 20) {
                                            ForEach(homeViewModel.games, id: \.id) { game in
                                                GeometryReader { geometry in
                                                    NavigationLink(destination: GameDetailsView(gameId: "")) {
                                                        GamesCardView()
                                                            .rotation3DEffect(
                                                                Angle(degrees: Double((geometry.frame(in: .global).minX - 30) / -20)),
                                                                axis: (x: 0, y: 10, z: 0)
                                                            )
                                                            .frame(width: 200, height: 220)
                                                            .background(Color.theme.background)
                                                    }
                                                }
                                                .frame(width: 200, height: 220)
                                               
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                    }
                                    
                                    Text("Platforms")
                                        .font(
                                            Font.custom("Orbitron", size: 20)
                                                .weight(.medium)
                                        )
                                        .foregroundColor(Color(red: 0.07, green: 0.07, blue: 0.09))
                                        .padding(.horizontal, 16)
                                        .padding(.top, 10)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 20) {
                                            ForEach(homeViewModel.platforms?.results ?? [], id: \.id) { platform in
                                                NavigationLink(destination: GameDetailsView(gameId: platform.slug ?? "")) {
                                                    PlatformCardDetails()
                                                        .transition(.move(edge: .trailing))
                                                        .animation(.easeInOut(duration: 0.5), value: scrollAnimation)
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                    }
                                    .padding(.bottom, 10)
                                    
                                    Text("Latest Games")
                                        .font(
                                            Font.custom("Orbitron", size: 20)
                                                .weight(.medium)
                                        )
                                        .foregroundColor(Color(red: 0.07, green: 0.07, blue: 0.09))
                                        
                                        .padding(.horizontal, 16)
                                        .padding(.top, 10)
                                    
                                    ScrollView(.vertical, showsIndicators: false) {
                                        VStack(spacing: 20) {
                                            ForEach(homeViewModel.bestGames, id: \.id) { bestGame in
                                                NavigationLink(destination: GameDetailsView(gameId: bestGame.slug ?? "")) {
                                                    LatestGamesCardView()
                                                        .transition(.move(edge: .bottom))
                                                        .animation(.easeInOut(duration: 0.5), value: scrollAnimation)
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 16)
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
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .preference(key: ScrollViewOffsetPreferenceKey.self, value: geo.frame(in: .global).minY)
                                }
                            )
                        }
                        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                            withAnimation {
                                showScrollToTopButton = value < -200
                                print("Scroll offset: \(value), Show button: \(showScrollToTopButton)")
                            }
                        }
                        .overlay(
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
                        )
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
            .environmentObject(HomeViewModel())
    }
}
