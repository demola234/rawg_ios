//
//  PlatformCardDetails.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 28/07/2024.
//

import SwiftUI

struct PlatformCardDetails: View {
    var body: some View {
        ZStack {
            Image("Games")
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fill)
                .frame(width: 210, height: 60)
                .cornerRadius(10)
                .overlay {
                    Rectangle()
                        .foregroundColor(.black.opacity(0.37))
                        .cornerRadius(10)
                }
            
            Text("Action")
                .font(Font.custom("Orbitron", size: 14).weight(.medium))
                .foregroundColor(.white)
        }
        .frame(width: 210, height: 60)
        .cornerRadius(10)
    }
}

#Preview {
    PlatformCardDetails()
}
