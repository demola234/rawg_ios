//
//  Toogle.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 31/07/2024.
//

import Foundation
import SwiftUI

/// A custom `ToggleStyle` that represents a checkbox-style toggle.
struct CheckboxToggleStyle: ToggleStyle {
    
    /// Creates the view representing the toggle.
    ///
    /// - Parameter configuration: The configuration object that provides the state of the toggle.
    /// - Returns: A `View` that represents the toggle's appearance and behavior.
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Button(action: {
                configuration.isOn.toggle()
            }) {
                RoundedRectangle(cornerRadius: 3)
                    .frame(width: 20, height: 20)
                    .foregroundColor(configuration.isOn ? .theme.goldColor : .theme.background)
                    .background(configuration.isOn ? Color.theme.goldColor : Color.theme.background)
                    .cornerRadius(3)
                    .overlay(
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(Color.theme.primaryTextColor, lineWidth: 1)
                    )
            }
            .buttonStyle(PlainButtonStyle())
            .animation(.easeInOut, value: configuration.isOn)
            .padding(.trailing, 5)
        }
    }
}
