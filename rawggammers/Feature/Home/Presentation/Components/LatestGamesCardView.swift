//
//  LatestGamesCardView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 28/07/2024.
//

import SwiftUI

/// A view that displays a card for the latest games.
///
/// The `LatestGamesCardView` presents a card with a background image, the game's name, and platform images. The card has a rounded corner design and displays a shadow for a polished appearance.
struct LatestGamesCardView: View {
    /// The details of the game to be displayed.
    var gameDetails: ResultData
    
    var body: some View {
        ZStack {
            // Display the background image if available
            if let imageUrl = URL(string: gameDetails.backgroundImage ?? "") {
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
                                // Display the game name
                                Text("\(gameDetails.name ?? "")")
                                    .customFont(CustomFont.orbitronSemiBold.copyWith(size: 14))
                                    .foregroundColor(.theme.primaryTextColor)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                
                                Spacer()
                                
                                // Display platform images
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

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    /// Applies a corner radius to specific corners of a view.
    /// - Parameters:
    ///   - radius: The radius of the rounded corners.
    ///   - corners: The corners to round.
    /// - Returns: A view with rounded corners.
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct LatestGamesCardView_Previews: PreviewProvider {
    static var previews: some View {
        LatestGamesCardView(gameDetails: dev.gamesData.results.first!)
            .previewLayout(.sizeThatFits)
    }
}
