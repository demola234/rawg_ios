//
//  GameDetailsView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 28/07/2024.
//

import SwiftUI
import AVKit

struct GameDetailsView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    var gameId: String
    
    var body: some View {
        DetailsView(gameDetail: homeViewModel.gameDetails)
            .onAppear {
                homeViewModel.getGameDetails(game: gameId)
            }
            .hideTabBar(true)
    }
      
       
}

struct DetailsView: View {
    let gameDetail: ResultData?
    @State private var showFullDescription: Bool = false
    @State private var selectedScreenshot: Int? = nil
    @State private var player = AVPlayer(url: URL(string: "https://steamcdn-a.akamaihd.net/steam/apps/256681415/movie480.mp4")!)
    @State private var showFullScreenVideo = false
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
           
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack {
                    
                    GameHeaderView(gameDetail: gameDetail)
                        .ignoresSafeArea()
                    
                    RatingsView()
                    
//                    VStack(alignment: .leading, spacing: 10) {
//                        SectionTitleView(title: gameDetail?.name ?? "Title")
//                        
//                        DescriptionView(showFullDescription: $showFullDescription)
//                    }
//                    .padding(.horizontal, 16)
//                    
//                    GameInfoView()
//                        .padding(.horizontal, 16)
//                    
//                    SectionTitleView(title: "Screenshots")
//                        .padding(.horizontal, 16)
//                    
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 10) {
//                            ForEach(0..<5, id: \.self) { index in
//                                Image("Games")
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(width: 200, height: 240)
//                                    .cornerRadius(10)
//                                    .onTapGesture {
//                                        withAnimation {
//                                            selectedScreenshot = index
//                                        }
//                                    }
//                            }
//                        }
//                        .padding(.horizontal, 16)
//                    }
                    
//                    SectionTitleView(title: "Video")
//                        .padding(.horizontal, 16)
//                    
//                    VideoPlayerView(player: $player)
//                        .frame(height: 300)
//                        .cornerRadius(10)
//                        .padding(.horizontal, 16)
//                        .onTapGesture {
//                            showFullScreenVideo.toggle()
//                        }
//                    
//                    Spacer()
                }
            }
            .coordinateSpace(name: "scroll")
            .ignoresSafeArea()
            
            if selectedScreenshot != nil {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            self.selectedScreenshot = nil
                        }
                    }
                
                VStack {
                    Spacer()
                    
                    Image("Games")
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width - 60, height: UIScreen.main.bounds.height / 2)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                        .transition(.scale)
                        .onTapGesture {
                            withAnimation {
                                self.selectedScreenshot = nil
                            }
                        }
                    
                    Spacer()
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showFullScreenVideo) {
            FullScreenVideoPlayer(player: player)
        }
    }
}

struct VideoPlayerView: View {
    @Binding var player: AVPlayer
    
    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                player.play()
            }
            .onDisappear {
                player.pause()
            }
    }
}

struct FullScreenVideoPlayer: View {
    var player: AVPlayer
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            VideoPlayer(player: player)
                .ignoresSafeArea()
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Close")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
            .padding()
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct GameDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        GameDetailsView(gameId: "")
            .environmentObject(HomeViewModel())
    }
}
