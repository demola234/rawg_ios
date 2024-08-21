//
//  AboutUsView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 21/08/2024.
//

import SwiftUI

struct AboutUsView: View {
        var body: some View {
            VStack(spacing: 20) {
                Text("About Us")
                    .customFont(CustomFont.orbitronMedium.copyWith(size: 18))
                    .foregroundColor(.theme.primaryTextColor)
                
                Text("RawgGammers is a gaming platform where users can explore and track their favorite games. Developed by Ademola Kolawole.")
                    .customFont(CustomFont.orbitronRegular.copyWith(size: 14))
                    .foregroundColor(.theme.primaryTextColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
            }
            .padding(.vertical, 20)
        }
}

#Preview {
    AboutUsView()
}
