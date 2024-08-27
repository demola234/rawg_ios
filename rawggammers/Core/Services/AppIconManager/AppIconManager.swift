//
//  AppIconManager.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 20/08/2024.
//

import Foundation
import SwiftUI

/// `AppIconManager` is a class responsible for managing the app's icons, allowing users to switch between the primary and alternate icons.
/// It is an `ObservableObject`, making it suitable for use with SwiftUI's data-binding features.
public final class AppIconManager: ObservableObject {
    
    // MARK: - Properties
    
    /// Published property that keeps track of the currently selected icon's index.
    @Published public var iconIndex: Int = 0
    
    /// Array of available icons that can be used to switch the app's icon.
    public private(set) var icons: [Icon] = []
    
    /// The name of the currently selected icon. Returns `nil` if the primary icon is in use.
    public var currentIconName: String? {
        UIApplication.shared.alternateIconName
    }
    
    // MARK: - Initializer
    
    /// Initializes the `AppIconManager` and loads the available icons from the app's bundle.
    public init() {
        loadIcons()
    }
    
    // MARK: - Private Methods
    
    /// Loads the available icons from the app's `Info.plist` file, including both the primary and alternate icons.
    private func loadIcons() {
        if let bundleIcons = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any] {
            
            // Load the default primary icon
            if let primaryIcon = bundleIcons["CFBundlePrimaryIcon"] as? [String: Any],
               let iconFileName = (primaryIcon["CFBundleIconFiles"] as? [String])?.first {
                let displayName = (primaryIcon["CFBundleIconName"] as? String) ?? ""
                
                // Append the primary icon to the icons array, with `nil` as the icon name for reset purposes.
                icons.append(
                    Icon(displayName: displayName, iconName: nil, image: UIImage(named: iconFileName))
                )
            }
            
            // Load alternate icons
            if let alternateIcons = bundleIcons["CFBundleAlternateIcons"] as? [String: Any] {
                alternateIcons.forEach { iconName, iconInfo in
                    if let iconInfo = iconInfo as? [String: Any],
                       let iconFileName = (iconInfo["CFBundleIconFiles"] as? [String])?.first {
                        
                        // Append each alternate icon to the icons array
                        icons.append(
                            Icon(displayName: iconName, iconName: iconName, image: UIImage(named: iconFileName))
                        )
                    }
                }
            }
        }
        
        // Set the icon index to match the currently selected icon, or default to 0 if none is selected.
        iconIndex = icons.firstIndex(where: { icon in
            return icon.iconName == currentIconName
        }) ?? 0
    }
}

// MARK: - Icon Struct

/// `Icon` is a struct representing an app icon, including its display name, icon name, and image.
///
/// - Parameters:
///   - displayName: The name displayed for the icon.
///   - iconName: The actual name used for the icon, or `nil` for the primary icon.
///   - image: The `UIImage` representing the icon.
public struct Icon {
    public let displayName: String
    public let iconName: String?
    public let image: UIImage?
}
