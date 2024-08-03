//
//  DescriptionView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 29/07/2024.
//

import SwiftUI

struct DescriptionView: View {
    @Binding var showFullDescription: Bool
    var description: String
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                
                Text("About")
                    .customFont(CustomFont.orbitronBold.copyWith(size: 16))
                    .foregroundColor(Color.theme.accentTextColor)
                    .padding(.bottom, 5)
                
                Text(description.removingHTMLOccurances)
                    .customFont(CustomFont.orbitronRegular.copyWith(size: 14))
                    .lineLimit(showFullDescription ? nil : 5)
                
                Button(action: {
                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
                        showFullDescription.toggle()
                    }
                }) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 90, height: 20)
                        .background(Color.theme.accentTextColor)
                        .overlay(
                            Text(showFullDescription ? "Less" : "Read more...")
                                .customFont(CustomFont.orbitronSemiBold.copyWith(size: 7))
                                .padding(.vertical, 6)
                                .foregroundColor(Color.theme.primaryTextColor)
                        )
                        .cornerRadius(5)
                }
                .accentColor(.theme.primaryTextColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    DescriptionView(showFullDescription: .constant(false), description:  "")
}
