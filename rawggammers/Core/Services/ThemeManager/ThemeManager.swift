//
//  ThemeManager.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 18/08/2024.
//

import Foundation
import SwiftUI

/// `ThemeManager` is a class responsible for managing the app's theme settings, allowing users to switch between light, dark, and system themes.
/// It conforms to the `ObservableObject` protocol, making it compatible with SwiftUI's data-binding features.
class ThemeManager: ObservableObject {
    
    // MARK: - Properties
    
    /// Stores the raw value of the selected theme in `AppStorage`, allowing the theme setting to persist across app launches.
    @AppStorage("selectedTheme") private var selectedThemeRawValue: String = Theme.system.rawValue {
        didSet {
            applyTheme()
        }
    }
    
    /// Published property that keeps track of the currently selected theme.
    @Published var currentTheme: Theme = .system
    
    // MARK: - Initializer
    
    /// Initializes the `ThemeManager` by loading the saved theme from `AppStorage` when the app starts.
    /// If no theme is saved, the default theme is set to light mode.
    init() {
        currentTheme = Theme(rawValue: selectedThemeRawValue) ?? .light
        applyTheme()
    }
    
    // MARK: - Methods
    
    /// Switches the app's theme to the specified `Theme`.
    ///
    /// - Parameter theme: The theme to switch to (`light`, `dark`, or `system`).
    func switchTheme(to theme: Theme) {
        currentTheme = theme
        selectedThemeRawValue = theme.rawValue
    }
    
    /// Applies the current theme by setting the user interface style for the app's window.
    /// This method adjusts the app's appearance based on the selected theme.
    private func applyTheme() {
        guard let window = UIApplication.shared.windows.first else { return }
        
        switch currentTheme {
        case .dark:
            window.overrideUserInterfaceStyle = .dark
        case .light:
            window.overrideUserInterfaceStyle = .light
        case .system:
            window.overrideUserInterfaceStyle = .unspecified
        }
    }
}

// MARK: - Theme Enum

/// `Theme` is an enumeration that represents the possible themes for the app.
/// It conforms to the `String` and `Codable` protocols, making it easy to store and retrieve the selected theme from `AppStorage`.
///
/// - light: The light mode theme.
/// - dark: The dark mode theme.
/// - system: The system default theme, which follows the device's appearance settings.
enum Theme: String, Codable {
    case light, dark, system
}
