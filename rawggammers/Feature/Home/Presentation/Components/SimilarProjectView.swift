//
//  SimilarProjectView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 02/08/2024.
//

import SwiftUI

/// A view that displays a card for similar projects or games.
///
/// The `SimilarProjectView` presents a card with a background image and information about similar games, including a name and a placeholder for additional information. The card features a rounded rectangle shape with a bottom overlay.
struct SimilarProjectView: View {
    /// The genre or game data to be displayed.
    var similarGames: Genre
    
    var body: some View {
        ZStack {
            // Display the background image if available
            if let imageUrl = URL(string: similarGames.imageBackground ?? "") {
                NetworkImageView(imageURL: imageUrl)
                    .aspectRatio(contentMode: .fill)
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(alignment: .bottom) {
                        bottomOverlayView
                    }
                    .frame(width: 210, height: 250)
                    .background(Color.theme.cardColor)
                    .cornerRadius(20)
            }
        }
        .frame(width: 210, height: 250)
        .cornerRadius(20)
    }
    
    /// A view displayed at the bottom of the card overlay.
    private var bottomOverlayView: some View {
        UnevenRoundedRectangle(bottomLeadingRadius: 20, bottomTrailingRadius: 20)
            .foregroundColor(.theme.cardColor)
            .frame(height: 93)
            .alignmentGuide(.bottom) { d in d[.bottom] }
            .overlay {
                VStack(alignment: .leading, spacing: 5) {
                    // Placeholder for additional content, e.g., platform icons
                    nameView
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
            }
    }
    
    /// A view that displays the name of the genre or game.
    private var nameView: some View {
        Text("\(similarGames.name ?? "")")
            .customFont(CustomFont.orbitronSemiBold.copyWith(size: 12))
            .foregroundColor(.theme.primaryTextColor)
            .frame(maxWidth: 180, alignment: .leading)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 10)
    }
}
