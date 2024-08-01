//
//  GameHeaderView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 29/07/2024.
//

import SwiftUI

struct GameHeaderView: View {
    let gameDetail: ResultData?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if let imageUrl = URL(string: gameDetail?.backgroundImage ?? "") {
                NetworkImageView(imageURL: imageUrl)
                    .scaledToFill()
                    .frame(height: 300)
                    .clipped()
                    .overlay(alignment: .top) {
                        HStack {
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
                            Button {
                                
                            } label: {
                                Image(systemName: "bookmark")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
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
                        Text(gameDetail?.name ?? "S.T.A.L.K.E.R. 2: Heart of Chornobyl")
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
