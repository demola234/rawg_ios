//
//  SearchCardComponent.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 03/08/2024.
//

import SwiftUI

/// A custom SwiftUI view that displays a search result as a card with an image, title, and platform icons.
///
/// This component displays game search results with a background image, game title, and icons representing the platforms the game is available on. The platform icons are dynamically generated based on the search result data.
struct SearchCardComponent: View {
    
    /// The search result data containing details such as the game's background image, name, and platforms.
    var searchResult: ResultData
    
    var body: some View {
        ZStack {
            // Display the background image from the search result
            if let imageUrl = URL(string: searchResult.backgroundImage ?? "") {
                NetworkImageView(imageURL: imageUrl)
                    .scaledToFill()
                    .frame(width: 400, height: 230)
                    .clipped()
                    .cornerRadius(20)
                    .overlay(
                        // Add a border overlay with rounded corners
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .overlay(
                        VStack {
                            Spacer()
                            HStack {
                                // Display the game title with custom font
                                Text("\(searchResult.name ?? "")")
                                    .customFont(CustomFont.orbitronSemiBold.copyWith(size: 14))
                                    .foregroundColor(.theme.primaryTextColor)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                
                                Spacer()
                                
                                // Display platform icons
                                HStack {
                                    let uniquePlatformNames = Array(Set(searchResult.platforms?.compactMap {
                                        $0.platform?.name?.lowercased().split(separator: " ").first
                                    } ?? []).prefix(5))
                                    
                                    // Map platform names to their corresponding images
                                    let platformImages: [String: String] = uniquePlatformNames.reduce(into: [:]) { result, platformName in
                                        if let platform = searchResult.platforms?.first(where: { $0.platform?.name?.lowercased().split(separator: " ").first == platformName }) {
                                            if let platformImage = platform.platform?.getImages(platform: String(platformName)) {
                                                result[String(platformName)] = platformImage
                                            }
                                        }
                                    }
                                    
                                    // Display the platform images
                                    ForEach(platformImages.keys.sorted(), id: \.self) { platformName in
                                        if let platformImage = platformImages[platformName] {
                                            Image(platformImage)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 15, height: 15)
                                        }
                                    }
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                            }
                            .frame(height: 80)
                            .background(Color.theme.cardColor)
                            .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
                        }
                    )
            }
        }
        .frame(width: 400, height: 230)
        .background(Color.theme.cardColor)
        .cornerRadius(20)
        .shadow(color: Color.theme.background.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

/// A preview of the `SearchCardComponent` with mock data.
struct SearchCardComponent_Previews: PreviewProvider {
    static var previews: some View {
        LatestGamesCardView(gameDetails: dev.gamesData.results.first!)
            .previewLayout(.sizeThatFits)
    }
}
