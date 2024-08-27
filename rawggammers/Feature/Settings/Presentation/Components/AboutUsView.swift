//
//  AboutUsView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 21/08/2024.
//

import SwiftUI

/// A view that displays information about the application.
///
/// This view presents a title "About Us" and a description of the app, including its purpose and developer details.
///
/// - Content:
///   - A title with the text "About Us".
///   - A description of the RawgGammers platform and its developer.
///   - Spacing and padding are applied for layout adjustments.
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
