//
//  AvatarSettingsView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 20/08/2024.
//

import SwiftUI

struct AvatarSettingsView: View {
    var body: some View {
            HStack {
                Image("Games")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .frame(width: 49, height: 49)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Change Avatar")
                        .customFont(CustomFont.orbitronSemiBold.copyWith(size: 18))
                        .foregroundColor(.theme.primaryTextColor)
                    
                    Text("Update or choose a new avatar")
                        .customFont(CustomFont.poppinsRegualr.copyWith(size: 14))
                        .foregroundColor(.theme.primaryTextColor)
                }
                
                Spacer()
                
                Image("left_arrow")
                    .resizable()
                    .foregroundColor(.theme.primaryTextColor)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20)
                    .clipped()
                
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(Color.theme.cardColor)
            .cornerRadius(20)
        }
    }

#Preview {
    AvatarSettingsView()
}
