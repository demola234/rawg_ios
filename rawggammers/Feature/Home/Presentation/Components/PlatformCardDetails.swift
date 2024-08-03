//
//  PlatformCardDetails.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 28/07/2024.
//

import SwiftUI

struct PlatformCardDetails: View {
    var platformDetails: PlatformResult
    
    var body: some View {
        ZStack {
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
