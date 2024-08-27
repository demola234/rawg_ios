//
//  CustomButton.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 25/07/2024.
//

import SwiftUI

/// `CustomButton` is a versatile and customizable button component for SwiftUI.
/// It supports text labels, optional icons, custom colors, and enables/disables functionality.
struct CustomButton: View {
    
    // MARK: - Properties
    
    /// The action to perform when the button is tapped.
    var action: () -> Void
    
    /// The text label displayed on the button.
    var title: String
    
    /// Boolean indicating whether the button is enabled. Default is `true`.
    var isEnable: Bool = true
    
    /// The name of an optional image to display on the button.
    var imageName: String? = nil
    
    /// The background color of the button.
    var backgroundColor: Color
    
    /// The border color of the button. Default is `Color.clear`.
    var borderColor: Color? = Color.clear
    
    /// The text color of the button label. Default is `.theme.textFieldColor`.
    var textColor: Color = .theme.textFieldColor
    
    // MARK: - Body
    
    var body: some View {
        Button(action: isEnable ? action : {}) {
            HStack {
                if let imageName = imageName {
                    Image(imageName)
                        .font(.headline)
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                
                Text(title)
                    .customFont(CustomFont.orbitronBold.copyWith(size: 13))
                    .fontWeight(.bold)
                    .foregroundColor(isEnable ? textColor : .theme.background)
            }
            .padding(EdgeInsets(top: 12, leading: 10, bottom: 12, trailing: 10))
            .frame(width: 400, height: 45)
            .background(isEnable ? backgroundColor : Color.theme.accentTextColor)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor ?? Color.clear, lineWidth: 1) 
            )
        }
    }
}

// MARK: - Preview

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomButton(action: {}, title: "Create Account with Email", imageName: nil, backgroundColor: .black)
                .previewLayout(.sizeThatFits)
                .padding()
                .preferredColorScheme(.light)
            
            CustomButton(action: {}, title: "Create Account with Email", imageName: nil, backgroundColor: .black, borderColor: nil)
                .previewLayout(.sizeThatFits)
                .padding()
                .preferredColorScheme(.dark)
        }
    }
}
