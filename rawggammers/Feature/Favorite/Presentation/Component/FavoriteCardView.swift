//
//  FavoriteCardView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 03/08/2024.
//

import SwiftUI

/// A SwiftUI view that displays a card for a favorite entity.
///
/// This view shows a card with an image and the name of a favorite entity. The image is fetched from a URL and displayed as the background of the card. The card also has rounded corners and a shadow effect.
struct FavoriteCardView: View {
    /// The favorite entity to be displayed in the card.
    var favorite: FavoriteEntity
    
    var body: some View {
        ZStack {
            if let imageUrl = URL(string: favorite.backgroundImage ?? "") {
                NetworkImageView(imageURL: imageUrl)
                    .scaledToFill()
                    .frame(width: 400, height: 230)
                    .clipped()
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .overlay(
                        VStack {
                            Spacer()
                            HStack {
                                Text("\(favorite.name ?? "")" )
                                    .customFont(CustomFont.orbitronSemiBold.copyWith(size: 14))
                                    .foregroundColor(.theme.primaryTextColor)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                
                                Spacer()
                                
                                // Placeholder for platform images or additional information
                                // Uncomment and implement if needed
                                /*
                                HStack {
                                    let uniquePlatformNames = Array(Set(gameDetails.platforms?.compactMap { $0.platform?.name?.lowercased().split(separator: " ").first } ?? []).prefix(5))
                                    
                                    // Map the platform names to their corresponding images
                                    let platformImages: [String: String] = uniquePlatformNames.reduce(into: [:]) { result, platformName in
                                        if let platform = gameDetails.platforms?.first(where: { $0.platform?.name?.lowercased().split(separator: " ").first == platformName }) {
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
                                                .frame(width: 15, height: 15)
                                        }
                                    }
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                */
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

struct FavoriteCardView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteCardView(favorite: FavoriteEntity(id: "1", slug: "example-slug", name: "Example Game", released: "2024-01-01", backgroundImage: "https://example.com/image.jpg", rating: 4.5, suggestionsCount: 10, updated: "2024-01-01", reviewsCount: 100))
            .previewLayout(.sizeThatFits)
    }
}
