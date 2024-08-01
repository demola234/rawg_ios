//
//  PlaceHolder.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 25/07/2024.
//

import Foundation
import SwiftUI

extension View {
    func placeholder<Content: View>(when shouldShow: Bool, placeholder: Content) -> some View {
        ZStack(alignment: .leading) {
            if shouldShow {
                placeholder
                    .padding(.leading, 8)
                    .foregroundColor(Color.theme.accentTextColor)
            }
            self
        }
    }
}
