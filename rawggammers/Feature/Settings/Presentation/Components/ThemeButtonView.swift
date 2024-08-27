//
//  ThemeButtonView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 21/08/2024.
//

import SwiftUI

/// A view representing a theme selection button with customizable appearance based on the current theme.
///
/// This view displays a button styled to represent a specific theme. It highlights the button if it matches the currently selected theme.
///
/// - Parameters:
///   - mode: The `Theme` representing the theme associated with this button.
///   - RightBg: The background color for the right part of the button.
///   - RightFg: The foreground color for the right part of the button.
///   - BottomBg: The background color for the bottom part of the button.
///   - BottomFg: The foreground color for the bottom part of the button.
///   - themeManager: An `EnvironmentObject` managing the current theme selection.
struct ThemeButtonSelection: View {
    var mode: Theme
    var RightBg: Color
    var RightFg: Color
    var BottomBg: Color
    var BottomFg: Color
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack {
            // Main button visual representation
            VStack {
                Circle()
                    .frame(width: 20, height: 20)
                RoundedRectangle(cornerRadius: 10.0)
                    .frame(width: 50, height: 6)
                VStack {
                    RoundedRectangle(cornerRadius: 10.0)
                        .frame(width: 38, height: 6)
                    RoundedRectangle(cornerRadius: 10.0)
                        .frame(width: 38, height: 6)
                    RoundedRectangle(cornerRadius: 10.0)
                        .frame(width: 38, height: 6)
                }
                .frame(width: 55, height: 50)
                .background(RightBg, in: RoundedRectangle(cornerRadius: 8.0))
                .foregroundColor(RightFg)
            }
            .padding(10)
            .foregroundColor(BottomFg)
            .background(BottomBg, in: RoundedRectangle(cornerRadius: 15.0))
            .overlay {
                if (themeManager.currentTheme == mode) {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.theme.primaryTextColor, lineWidth: 2)
                        .padding(-3)
                }
            }
            
            // Text displaying the theme name
            Text(String(describing: mode).capitalized)
                .foregroundStyle(themeManager.currentTheme == mode ? Color.theme.textFieldColor : Color.theme.primaryTextColor)
                .customFont(CustomFont.poppinsRegualr.copyWith(size: 15))
                .frame(width: 80, height: 30, alignment: .center)
                .background(themeManager.currentTheme == mode ? Color.theme.primaryTextColor : Color.theme.cardColor, in: RoundedRectangle(cornerRadius: 10.0))
                .padding(.vertical, 10)
        }
    }
}

#Preview {
    ThemeButtonSelection(mode: Theme.system, RightBg: Color.theme.accentTextColor, RightFg: Color.white, BottomBg: Color.
