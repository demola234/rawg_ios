//
//  SectionTitleView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 29/07/2024.
//

import SwiftUI

struct SectionTitleView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(Font.custom("Orbitron", size: 14).weight(.bold))
            .foregroundColor(.white)
    }
}

#Preview {
    SectionTitleView()
}
