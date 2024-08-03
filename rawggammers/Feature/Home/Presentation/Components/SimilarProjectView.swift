//
//  SimilarProjectView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 02/08/2024.
//

import SwiftUI

struct SimilarProjectView: View {
    var similarGames: Genre
    
    var body: some View {
        ZStack {
            if let imageUrl = URL(string: similarGames.imageBackground ?? "") {
                NetworkImageView(imageURL: imageUrl)
                    .aspectRatio(contentMode: .fill)
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay (alignment: .bottom) {
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
    
    private var bottomOverlayView: some View {
        UnevenRoundedRectangle(bottomLeadingRadius: 20, bottomTrailingRadius: 20)
            .foregroundColor(.theme.cardColor)
            .frame(height: 93)
            .alignmentGuide(.bottom) { d in d[.bottom] }
            .overlay {
                VStack(alignment: .leading, spacing: 5) {
//                    platformIconsView
                    nameView
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
            }
    }
    
//    private var platformIconsView: some View {
//        HStack {
//            ForEach(getPlatformImages(), id: \.self) { platformImage in
//                Image(platformImage)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 15, height: 15)
//            }
//            
//            Spacer()
//            
//            ratingView
//        }
//        .padding(.horizontal, 10)
//        .frame(maxWidth: 200, alignment: .leading)
//    }
    
    private var ratingView: some View {
        RoundedRectangle(cornerRadius: 5)
            .foregroundColor(.clear)
            .frame(width: 35, height: 35)
            .background(Color.theme.background)
            .cornerRadius(5)
            .overlay {
                Text("\(similarGames.gamesCount ?? 0, specifier: "%.1f")")
                    .customFont(CustomFont.orbitronSemiBold.copyWith(size: 14))
                    .foregroundColor(.theme.primaryTextColor)
            }
    }
    
    private var nameView: some View {
        Text("\(similarGames.name ?? "")")
            .customFont(CustomFont.orbitronSemiBold.copyWith(size: 12))
            .foregroundColor(.theme.primaryTextColor)
            .frame(maxWidth: 180, alignment: .leading)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 10)
    }
    
//    private func getPlatformImages() -> [String] {
//        // Extract unique platform names and limit to the first 5
//        let uniquePlatformNames = Array(Set(similarGames?.?.compactMap { $0.platform?.name?.lowercased().split(separator: " ").first } ?? []).prefix(5))
//        
//        // Map the platform names to their corresponding images
//        let platformImages: [String] = uniquePlatformNames.compactMap { platformName in
//            if let platform = similarGames?.platforms?.first(where: { $0.platform?.name?.lowercased().split(separator: " ").first == platformName }) {
//                return platform.platform?.getImages(platform: String(platformName))
//            }
//            return nil
//        }
//        
//        return platformImages
//    }
}
