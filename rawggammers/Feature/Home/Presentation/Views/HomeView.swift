//
//  HomeView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(homeViewModel.games, id: \.id) { gameDetail in
                        NavigationLink(destination: GameDetailsView(gameId: gameDetail.slug ?? "")) {
                            HStack {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(gameDetail.name ?? "")
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                    
                                    Text(gameDetail.slug ?? "")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
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
                        .frame(height: 40)
                    }
                }
            }
            .navigationTitle("Home")
            .onAppear {
                homeViewModel.getGames()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeViewModel())
    }
}

struct GameDetailsView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    var gameId: String
    
    var body: some View {
        DetailsView(gameDetail: homeViewModel.gameDetails)
            .onAppear {
                homeViewModel.getGameDetails(game: gameId)
            }
    }
}

struct DetailsView: View {
    let gameDetail: ResultData?
    
    var body: some View {
        VStack {
            if let gameDetail = gameDetail {
                Text(gameDetail.name ?? "")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text(gameDetail.slug ?? "")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                // Add more details here as needed
            } else {
                Text("Loading...")
            }
        }
        .padding()
    }
}
