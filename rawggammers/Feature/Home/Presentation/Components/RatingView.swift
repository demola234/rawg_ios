//
//  RatingView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 29/07/2024.
//

import SwiftUI


struct RatingsView: View {
    var body: some View {
        VStack {
            HStack {
                HStack(spacing: 5) {
                    Image("ps")
                        .resizable()
                        .frame(width: 25, height: 25)
                    Image("windows")
                        .resizable()
                        .frame(width: 25, height: 25)
                    Image("xbox")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                
                Spacer()
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 54, height: 29)
                    .background(Color.white)
                    .cornerRadius(25)
                    .overlay(
                        Text("72")
                            .font(Font.custom("Orbitron", size: 14).weight(.bold))
                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    )
            }
            .padding(.bottom, 10)
            
            Text("Exceptional")
                .font(Font.custom("Orbitron", size: 14).weight(.bold))
                .foregroundColor(.white)
                .padding(.bottom, 10)
            
            Text("167 RATINGS")
                .font(Font.custom("SF Pro Text", size: 14).weight(.bold))
                .kerning(4.06)
                .foregroundColor(Color(red: 0.75, green: 0.76, blue: 0.79))
        }
    }
}


#Preview {
    RatingsView()
}
