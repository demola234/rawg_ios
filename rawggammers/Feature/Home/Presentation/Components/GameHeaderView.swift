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
            Image("Games")
                .resizable()
                .scaledToFill()
                .frame(height: 300)
                .clipped()
            
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
    GameHeaderView(gameDetail: )
}
