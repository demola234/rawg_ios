//
//  GamesCardView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 28/07/2024.
//

import SwiftUI

struct GamesCardView: View {
    var body: some View {
        ZStack {
            Image("Games")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .scaledToFit()
                .clipShape(.rect(cornerRadius: 20))
                .overlay (alignment: .bottom) {
                    UnevenRoundedRectangle(bottomLeadingRadius: 20, bottomTrailingRadius: 20)
                        .foregroundColor(.black)
                        .frame(height: 93)
                        .alignmentGuide(.bottom) { d in d[.bottom] }
                        .overlay {
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    HStack (spacing: 5) {
                                       Image("ps")
                                            .frame(width: 15, height: 15)
                                        Image("windows")
                                            .frame(width: 15, height: 15)
                                        Image("xbox")
                                            .frame(width: 15, height: 15)
                                    }
                                    Spacer()
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundColor(.clear)
                                        .frame(width: 35, height: 35)
                                        .background(Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.7))
                                        .cornerRadius(5)
                                        .overlay {
                                            Text("9.5")
                                                .font(
                                                Font.custom("Orbitron", size: 14)
                                                .weight(.bold)
                                                )
                                                .foregroundColor(.white)
                                                
                                        }
                                }
                                
                                Text("Vampire: The Masquerade - Bloodlines 2")
                                  .font(
                                    Font.custom("Orbitron", size: 12)
                                      .weight(.bold)
                                  )
                                  .foregroundColor(.white)
                                  .frame(width: 180, alignment: .leading)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                        }
                }
                .cornerRadius(20)
        }
        .frame(width: 210, height: 250)
        .background(.white)
        .cornerRadius(20)
    }
}

#Preview {
    GamesCardView()
}
