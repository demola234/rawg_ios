//
//  PlatformCardView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 25/08/2024.
//

import SwiftUI

/// A view that displays a card for a gaming platform.
///
/// `PlatformCardView` is used to show a card with details about a gaming platform, including its background image and name. The card is styled with a rounded corner and an overlay for better visibility of the text.

struct PlatformCardView: View {
    /// The details of the platform to be displayed on the card.
    var platformDetails: PlatformResult
    
    var body: some View {
        ZStack {
            // Background Image
            if let imageUrl = URL(string: platformDetails.platforms?.first.map({ $0.imageBackground ?? "" }) ?? "") {
                NetworkImageView(imageURL: imageUrl)
                    .scaledToFill()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 210, height: 60)
                    .cornerRadius(10)
                    .overlay {
                        Rectangle()
                            .foregroundColor(.black.opacity(0.37))
                            .cornerRadius(10)
                    }
            }
            
            // Platform Name
            Text(platformDetails.name ?? "Unknown")
                .customFont(CustomFont.orbitronMedium.copyWith(size: 14))
                .foregroundColor(.white)
        }
        .frame(width: 210, height: 60)
        .cornerRadius(10)
    }
}

struct PlatformCardView_Previews: PreviewProvider {
    static var previews: some View {
        PlatformCardView(platformDetails: dev.platform.results![0])
    }
}
