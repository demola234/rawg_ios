//
//  InfoRowView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 29/07/2024.
//

import SwiftUI

struct InfoRowView: View {
    let title: String
    let value: String
    var isLink: Bool = false
    
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
                    .foregroundColor(isLink ? .theme.goldColor :.theme.primaryTextColor)
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
