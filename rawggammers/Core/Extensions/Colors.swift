//
//  Colors.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 25/07/2024.
//

import Foundation
import SwiftUI

extension Color {
    static let theme =  ColorTheme()
    static let launch = LaunchTheme()
}

struct ColorTheme {
    let background = Color("BackgroundColor")
    let primaryTextColor = Color("PrimaryTextColor")
    let accentTextColor = Color("AccentTextColor")
    let textFieldColor = Color("TextFieldColor")
}


struct LaunchTheme {
    let launchText = Color("LaunchTextColor")
    let background = Color("LaunchBackgroundColor")
}
