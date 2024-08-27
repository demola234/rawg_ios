//
//  SettingsCardView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 20/08/2024.
//

import SwiftUI

/// A view representing a card used in settings screens.
///
/// This view displays a settings card with an icon, title, optional subtitle, and a navigation arrow.
///
/// - Parameters:
///   - title: A `String` representing the main title of the card.
///   - subTitle: An optional `String` for additional information or description under the title.
///   - background: An optional `Color` for the background of the card. Defaults to `Color.theme.cardColor`.
///   - textColor: An optional `Color` for the text color. Defaults to `Color.theme.primaryTextColor`.
///   - icon: A `String` representing the name of the image asset to be used as the icon.
struct SettingsCardView: View {
    var title: String
    var subTitle: String?
    var background: Color? = Color.theme.cardColor
    var textColor: Color? = Color.theme.primaryTextColor
    var icon: String
    
    var body: some View {
        HStack {
            // Icon section
            VStack {}
                .frame(width: 49, height: 49)
                .background(Color.theme.accentTextColor.opacity(0.2))
                .clipShape(Circle())
                .overlay(content: {
                    Image(icon)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .foregroundColor(.theme.primaryTextColor)
                        .frame(width: 24, height: 24, alignment: .center)
                })
            
            // Title and subtitle
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .customFont(CustomFont.orbitronSemiBold.copyWith(size: 18))
                    .foregroundColor(textColor)
                
                if let subTitle = subTitle {
                    Text(subTitle)
                        .customFont(CustomFont.poppinsRegualr.copyWith(size: 14))
                        .foregroundColor(.theme.primaryTextColor)
                }
            }
            
            Spacer()
            
            // Arrow icon
            Image("left_arrow")
                .resizable()
                .foregroundColor(textColor)
                .aspectRatio(contentMode: .fill)
                .frame(width: 20, height: 20)
                .clipped()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
        .background(background)
        .cornerRadius(20)
    }
}

#Preview {
    SettingsCardView(title: "Change Password", subTitle: "Modify your account", icon: "tag_user")
}
