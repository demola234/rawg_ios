//
//  InfoRowView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 29/07/2024.
//

import SwiftUI

/// A view that displays a row with a title and value, optionally styled as a clickable link.
///
/// The `InfoRowView` is designed to present a label (`title`) and its associated value (`value`). If the `isLink` flag is set to `true`, the value is styled as a clickable link, and tapping it opens the provided URL in a web browser.
struct InfoRowView: View {
    /// The title text to be displayed in the row.
    let title: String
    
    /// The value text to be displayed in the row. If `isLink` is true, this text is treated as a URL.
    let value: String
    
    /// A flag indicating whether the `value` text should be styled as a clickable link.
    var isLink: Bool = false
    
    /// A default URL used if the value URL is invalid.
    let defaultUrl = URL(string:"https://rawgclone.olarotimi.dev/").unsafelyUnwrapped
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .customFont(CustomFont.orbitronSemiBold.copyWith(size: 12))
                    .foregroundColor(.theme.primaryTextColor)
                    .padding(.vertical, 5)
                
                Text(value)
                    .customFont(CustomFont.orbitronNormal.copyWith(size: 10))
                    .foregroundColor(isLink ? .theme.goldColor : .theme.primaryTextColor)
                    .underline(isLink, color: .theme.goldColor)
                    .onTapGesture {
                        if isLink {
                            let url = URL(string: value)
                            UIApplication.shared.open(url ?? defaultUrl, options: [:], completionHandler: nil)
                        }
                    }
                    .padding(.vertical, 5)
            }
            Spacer()
        }
    }
}

#Preview {
    InfoRowView(title: "TestTitle", value: "TestValue")
}
