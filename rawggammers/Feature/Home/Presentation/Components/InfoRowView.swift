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
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(Font.custom("Orbitron", size: 12).weight(.bold))
                    .foregroundColor(.white)
                Text(value)
                    .font(Font.custom("Orbitron", size: 10).weight(.medium))
                    .foregroundColor(Color(red: 0.75, green: 0.76, blue: 0.79))
            }
            Spacer()
        }
    }
}

#Preview {
    InfoRowView(title: "TestTitle", value: "TestValue")
}
