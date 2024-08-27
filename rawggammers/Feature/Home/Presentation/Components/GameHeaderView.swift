//
//  GameHeaderView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 29/07/2024.
//

import SwiftUI

/// A view that displays the header for a game detail screen, including a background image, navigation buttons, and a title.
///
/// The `GameHeaderView` shows a large background image with overlaying navigation buttons and a gradient background at the bottom containing the game's title.
struct GameHeaderView: View {
    /// The details of the game to display in the header.
    let gameDetail: ResultData?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background Image
            if let imageUrl = URL(string: gameDetail?.backgroundImage ?? "") {
                NetworkImageView(imageURL: imageUrl)
                    .scaledToFill()
                    .frame(height: 300)
                    .clipped()
                    .overlay(alignment: .top) {
                        HStack {
                            // Back Button
                            Button(action: {
                                print("Back")
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40, alignment: .center)
                                    .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                                    .clipShape(Circle())
                            }
                            Spacer()
                            // Bookmark Button
                            Button {
                                // Action for bookmark button
                            } label: {
                                Image(systemName: "bookmark")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40, alignment: .center)
                                    .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 30)
                    }
            }
            
            // Gradient Overlay with Title
            Rectangle()
                .foregroundColor(.clear)
                .frame(height: 144)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.8),
                            Color.theme.background
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .blur(radius: 10)
                .overlay(
                    HStack {
                        Text(gameDetail?.name ?? "")
                            .font(Font.custom("Orbitron", size: 23).weight(.medium))
                            .foregroundColor(Color.theme.primaryTextColor)
                            .padding(.horizontal, 16)
                            .padding(.top, 10)
                            .frame(alignment: .leading)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                )
                .offset(y: 40)
        }
        .frame(height: 310)
        .padding(.bottom, 20)
    }
}

#Preview {
    GameHeaderView(gameDetail: nil)
}
