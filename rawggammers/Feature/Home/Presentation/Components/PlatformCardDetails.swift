//
//  PlatformCardDetails.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 28/07/2024.
//

import SwiftUI

/// A view that displays details of a platform in a card format.
///
/// The `PlatformCardDetails` view presents a card with platform information, including an image and the platform's name. The image is fetched from a URL and displayed as the background of the card, with a semi-transparent overlay to enhance text readability.
struct PlatformCardDetails: View {
    /// The details of the platform to be displayed.
    var platformDetails: PlatformResult
    
    var body: some View {
        ZStack {
            // Display the background image if available
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
            
            // Display the platform name
            Text(platformDetails.name ?? "Unknown")
                .customFont(CustomFont.orbitronMedium.copyWith(size: 14))
                .foregroundColor(.white)
        }
        .frame(width: 210, height: 60)
        .cornerRadius(10)
    }
}

struct PlatformCardDetails_Previews: PreviewProvider {
    static var previews: some View {
        PlatformCardDetails(platformDetails: dev.platform.results![0])
    }
}
