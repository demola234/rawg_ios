//
//  GameDetailsView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 28/07/2024.
//
import SwiftUI
import AVKit

struct GameDetailsView: View {
    @Binding var gameDetails: ResultData?
    
    init(gameDetails: Binding<ResultData?>) {
        self._gameDetails = gameDetails
    }
    
    var body: some View {
        ZStack {
            if let gameDetail = gameDetails {
                DetailsView(gameDetail: gameDetail)
            }
        }
        .hideTabBar(true)
        .navigationBarHidden(true)
    }
}

struct DetailsView: View {
    let gameDetail: ResultData
    @StateObject private var homeViewModel: HomeViewModel
    @State private var showFullDescription: Bool = false
    @State private var selectedScreenshot: ShortScreenshot? = nil
    @State private var showFullScreenVideo = false
    @State private var player = AVPlayer()
    @Environment(\.dismiss) var dismiss
    @State private var selectedGameDetails: ResultData? = nil
    
    init(gameDetail: ResultData) {
        self.gameDetail = gameDetail
        _homeViewModel = StateObject(wrappedValue: HomeViewModel(gameDetails: gameDetail))
    }
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                ZStack {
                    if let imageUrl = URL(string: gameDetail.backgroundImage ?? "") {
                        NetworkImageView(imageURL: imageUrl)
                            .scaledToFill()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 500, alignment: .top)
                            .clipped()
                    }
                    
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: .theme.background.opacity(0.1), location: 0.00),
                            Gradient.Stop(color: .theme.background.opacity(0.8), location: 0.6),
                            Gradient.Stop(color: .theme.background, location: 0.80),
                            Gradient.Stop(color: .theme.background, location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.45, y: 0),
                        endPoint: UnitPoint(x: 0.45, y: 1)
                    )
                    
                    VStack {
                        HStack {
                            Button(action: {
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
                            
                            HStack(alignment: .center, spacing: 0) {
                                Image("favorite")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color.theme.primaryTextColor)
                                    .padding(8)
                            }
                            .padding(8)
                            .frame(width: 50, height: 50, alignment: .center)
                            .background(Color.theme.background)
                            .clipShape(Circle())
                        }
                        
                        Text("\(gameDetail.name ?? "")")
                            .customFont(CustomFont.orbitronSemiBold.copyWith(size: 24))
                            .foregroundColor(.theme.primaryTextColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .padding(.top, 100)
                            .padding(.vertical, 5)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 60)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        // Extract unique platform names and limit to the first 5
                        let uniquePlatformNames = Array(Set(gameDetail.platforms?.compactMap { $0.platform?.name?.lowercased().split(separator: " ").first } ?? []).prefix(5))
                        
                        // Map the platform names to their corresponding images
                        let platformImages: [String: String] = uniquePlatformNames.reduce(into: [:]) { result, platformName in
                            if let platform = gameDetail.platforms?.first(where: { $0.platform?.name?.lowercased().split(separator: " ").first == platformName }) {
                                if let platformImage = platform.platform?.getImages(platform: String(platformName)) {
                                    result[String(platformName)] = platformImage
                                }
                            }
                        }
                        
                        // Display the images in a ForEach loop
                        ForEach(platformImages.keys.sorted(), id: \.self) { platformName in
                            if let platformImage = platformImages[platformName] {
                                Image(platformImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                            }
                        }
                        
                        Spacer()
                        if (gameDetail.rating != nil) {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(.clear)
                                .frame(width: 54, height: 29)
                                .foregroundColor(.theme.background)
                                .background(Color.theme.primaryTextColor)
                                .cornerRadius(25)
                                .overlay {
                                    Text("\(gameDetail.rating ?? 0.0, specifier: "%.1f")")
                                        .customFont(CustomFont.orbitronSemiBold.copyWith(size: 16))
                                        .foregroundColor(.theme.background)
                                }
                        }
                    }
                    .padding(.horizontal, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    
                    if gameDetail.ratings != nil {
                        Text("\(gameDetail.ratings?.first.map { $0.title ?? "" }?.capitalizedFirstLetterOfEachWord ?? "")")
                            .customFont(CustomFont.orbitronSemiBold.copyWith(size: 14))
                            .foregroundColor(.theme.primaryTextColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 5)
                    }
                    
                    if (gameDetail.ratingsCount != nil) {
                        Text("\(gameDetail.ratingsCount ?? 0) RATINGS")
                            .customFont(CustomFont.orbitronSemiBold.copyWith(size: 14))
                            .kerning(5)
                            .foregroundColor(.theme.accentTextColor)
                            .padding(.horizontal, 24)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    if (gameDetail.description != nil) {
                        DescriptionView(showFullDescription: $showFullDescription, description: gameDetail.description ?? "")
                            .padding(.horizontal, 24)
                            .padding(.top, 20)
                    }
                    
                    GameInfoView(gameDetail: gameDetail)
                        .padding(.horizontal, 24)
                    
                    if let _ = gameDetail.shortScreenshots {
                        Text("Screenshots")
                            .customFont(CustomFont.orbitronSemiBold.copyWith(size: 14))
                            .foregroundColor(.theme.primaryTextColor)
                            .padding(.horizontal, 24)
                            .padding(.top, 20)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            if let screenshots = gameDetail.shortScreenshots {
                                ForEach(screenshots, id: \.id) { screenshot in
                                    NetworkImageView(imageURL: URL(string: screenshot.image ?? "")!)
                                        .scaledToFill()
                                        .frame(width: 200, height: 240)
                                        .cornerRadius(30)
                                        .onTapGesture {
                                            withAnimation {
                                                selectedScreenshot = screenshot
                                            }
                                        }
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    if let videos = homeViewModel.movies {
                        if let _ = URL(string: videos.results?.first?.data?.the480 ?? "") {
                            Text("Videos")
                                .customFont(CustomFont.orbitronSemiBold.copyWith(size: 14))
                                .foregroundColor(.theme.primaryTextColor)
                                .padding(.horizontal, 24)
                                .padding(.top, 20)
                        }
                    }
                    
                    if let videos = homeViewModel.movies {
                        if let videoUrl = URL(string: videos.results?.first?.data?.the480 ?? "") {
                            VideoPlayer(player: AVPlayer(url: videoUrl))
                                .onAppear {
                                    player.play()
                                }
                                .onDisappear {
                                    player.pause()
                                }
                                .frame(height: 170)
                                .cornerRadius(20)
                                .padding(.horizontal, 24)
                        }
                    }
                    
                    if homeViewModel.gameSeries != nil {
                        Text("More Games Like \(gameDetail.name?.capitalizedFirstLetterOfEachWord ?? "")")
                            .customFont(CustomFont.orbitronSemiBold.copyWith(size: 14))
                            .foregroundColor(.theme.primaryTextColor)
                            .padding(.horizontal, 24)
                            .padding(.top, 20)
                    }
                    
                    if let similarGames = homeViewModel.gameSeries {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(similarGames, id: \.id) { games in
                                    NavigationLink(destination: GameDetailsView(gameDetails: .constant(games))) {
                                        GamesCardView(gameData: games)
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                        .padding(.bottom, 10)
                    }
                }
            }
            
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
                    
                    NetworkImageView(imageURL: URL(string: selectedScreenshot?.image ?? "") ?? URL(string: "")!)
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width - 60, height: UIScreen.main.bounds.height / 2)
                        .background(Color.white)
                        .cornerRadius(20)
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
        .navigationBarHidden(true)
        .background(Color.theme.background)
        .ignoresSafeArea()
        .onAppear {
            homeViewModel.getMovies(game: gameDetail.slug ?? "")
            homeViewModel.getScreenshots(game: gameDetail.slug ?? "")
            homeViewModel.getSimilarGames(game: gameDetail.slug ?? "")
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

struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct GameDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GameDetailsView(gameDetails: .constant(dev.gamesData.results.first))
                .environmentObject(HomeViewModel())
        }
    }
}
