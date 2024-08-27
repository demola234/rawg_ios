//
//  AuthButton.swift
//  rawggammers
//
//  Created by Ademola Kolawole on [Date].
//

import SwiftUI

/// `AuthButton` is a customizable SwiftUI button designed for authentication-related actions, such as login or sign-up.
/// It supports optional images, custom colors, and enables/disables functionality.
struct AuthButton: View {
    
    // MARK: - Properties
    
    /// The action to perform when the button is tapped.
    var action: () -> Void
    
    /// Boolean indicating whether the button is enabled. Default is `true`.
    var isEnable: Bool = true
    
    /// The name of an optional image to display on the button.
    var imageName: String? = nil
    
    /// The background color of the button. Default is `.theme.background`.
    var backgroundColor: Color = .theme.background
    
    /// The border color of the button. Default is `.theme.accentTextColor`. Use `Color.clear` if no border is desired.
    var borderColor: Color? = Color.theme.accentTextColor
    
    /// The text color of the button. Default is `.theme.accentTextColor`.
    var textColor: Color = .theme.accentTextColor
    
    // MARK: - Body
    
    var body: some View {
        Button(action: action) {
            HStack {
                if let imageName = imageName {
                    Image(imageName)
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                
            }
            .padding()
            .background(backgroundColor)
            .frame(width: 120, height: 50)
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(borderColor ?? Color.clear, lineWidth: 1)
            )
        }
        .disabled(!isEnable)
    }
}

// MARK: - Preview

#Preview {
    AuthButton(action: {}, imageName: "GoogleLogo")
        .previewLayout(.sizeThatFits)
        .padding()
        .preferredColorScheme(.light)
}
