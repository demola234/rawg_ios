//
//  DescriptionView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 29/07/2024.
//

import SwiftUI

struct DescriptionView: View {
    @Binding var showFullDescription: Bool
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("S.T.A.L.K.E.R. 2 is a brand-new entry in the legendary series, enjoyed by millions of players worldwide. The explosive combination of first-person shooter, immersive sim and horror is back. It’s the ultimate S.T.A.L.K.E.R. experience of unprecedented scale, advanced graphics, freedom of choices")
                    .lineLimit(showFullDescription ? nil : 5)
                    .font(.callout)
                
                Button(action: {
                    withAnimation(.spring) {
                        showFullDescription.toggle()
                    }
                }) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 70, height: 20)
                        .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                        .overlay(
                            Text(showFullDescription ? "Less" : "Read more...")
                                .font(.caption)
                                .padding(.vertical, 4)
                                .foregroundColor(Color.theme.background)
                        )
                        .cornerRadius(5)
                }
                .accentColor(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    DescriptionView(showFullDescription: .constant(false))
}
