//
//  GameDetailsView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 28/07/2024.
//

import SwiftUI

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
    @State private var showFullDescription: Bool = false
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    GameHeaderView(gameDetail: gameDetail)
                    
                    RatingsView()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        SectionTitleView(title: "About")
                        
                        DescriptionView(showFullDescription: $showFullDescription)
                    }
                    .padding(.horizontal, 16)
                    
                    GameInfoView()
                        .padding(.horizontal, 16)
                }
            }
            .ignoresSafeArea()
        }
    }
}



struct GameDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        GameDetailsView(gameId: "")
            .environmentObject(HomeViewModel())
    }
}
