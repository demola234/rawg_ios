//
//  PlatformsDetailsView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 24/08/2024.
//
import SwiftUI

struct PlatformsDetailsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Binding var platform: PlatformResult?
    @State private var showDetailsView = false
    @State private var gameDetails: ResultData?
    @State private var hideHeader = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ZStack {
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
                        .background(GeometryReader { geo in
                            Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: geo.frame(in: .global).minY)
                        })
                    }
                }
                .onAppear {
                    homeViewModel.getGamesByPlatform(platform: platform?.id ?? 0)
                }
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    withAnimation {
                        hideHeader = value < -50
                    }
                }
            }
        }
        .navigationDestination(isPresented: $showDetailsView) {
            if gameDetails != nil {
                GameDetailsView(gameDetails: $gameDetails)
            }
        }
        .navigationBarHidden(true)
    }
    
    private func segue(selectedDetails: ResultData) {
        gameDetails = selectedDetails
        showDetailsView.toggle()
    }
}

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
