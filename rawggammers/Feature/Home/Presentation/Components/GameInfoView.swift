//
//  GameInfoView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 29/07/2024.
//

import SwiftUI

/// A view that displays detailed information about a game.
///
/// `GameInfoView` presents various details about a game, including platforms, genres, release date, developers, content rating, publishers, and a website link. The information is displayed using rows of key-value pairs.
struct GameInfoView: View {
    /// The detail data of the game to be displayed.
    let gameDetail: ResultData?
    
    var body: some View {
        VStack(alignment: .leading) {
            // Platforms and Genres Information
            HStack {
                let platforms = gameDetail?.platforms?.compactMap { $0.platform?.name }.joined(separator: ", ") ?? "No platforms available"
                let genres = gameDetail?.genres?.compactMap { $0.name }.joined(separator: ", ") ?? "No genres available"
                if (gameDetail?.platforms != nil) {
                    InfoRowView(title: "Platforms", value: platforms)
                }
                Spacer()
                if (gameDetail?.genres != nil) {
                    InfoRowView(title: "Genres", value: genres)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 32, alignment: .leading)
            
            // Release Date and Developers Information
            HStack {
                let releaseDate = gameDetail?.released ?? "TBA"
                let developers = gameDetail?.developers?.compactMap { $0.name }.joined(separator: ", ") ?? "No developers available"
                if (gameDetail?.released != nil) {
                    InfoRowView(title: "Release Date", value: releaseDate)
                }
                Spacer()
                if (gameDetail?.developers != nil) {
                    InfoRowView(title: "Developers", value: developers)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 32, alignment: .leading)
            
            // Content Rating and Publishers Information
            HStack {
                let contentRating = (gameDetail?.parentsCount ?? 0) == 0 ? "No Content Rating" : "\(gameDetail?.parentsCount ?? 0)"
                let publishers = gameDetail?.developers?.compactMap { $0.name }.joined(separator: ", ") ?? "No publishers available"

                if (gameDetail?.parentsCount != nil) {
                    InfoRowView(title: "Content Rating", value: contentRating)
                }
                Spacer()
                if (gameDetail?.developers != nil) {
                    InfoRowView(title: "Publishers", value: publishers)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 32, alignment: .leading)
            
            // Website Information
            if let website = gameDetail?.website {
                InfoRowView(title: "Website", value: website, isLink: true)
            }
        }
    }
}

struct GameInfoView_Previews: PreviewProvider {
    static var previews: some View {
        GameInfoView(gameDetail: dev.gamesData.results.first.map { $0 })
    }
}
