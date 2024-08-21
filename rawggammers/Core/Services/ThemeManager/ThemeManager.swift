//
//  ThemeManager.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 18/08/2024.
//

import Foundation
import SwiftUI

class ThemeManager: ObservableObject {
    @AppStorage("selectedTheme") private var selectedThemeRawValue: String = Theme.system.rawValue {
        didSet {
            applyTheme()
        }
    }
    
    @Published var currentTheme: Theme = .system
    
    init() {
        // Load the saved theme when the app starts
        currentTheme = Theme(rawValue: selectedThemeRawValue) ?? .light
        applyTheme()
    }
    
    func switchTheme(to theme: Theme) {
        currentTheme = theme
        selectedThemeRawValue = theme.rawValue
    }
    
    private func applyTheme() {
        // Here you can apply the selected theme using custom colors
        // or using the default light/dark mode
        if currentTheme == .dark {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
        } else if (currentTheme == .light) {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
        } else {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .unspecified
        }
    }
}

enum Theme: String, Codable {
    case light, dark, system
}
