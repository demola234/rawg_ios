//
//  TabBar.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 01/08/2024.
//

import Foundation
import SwiftUI

private struct HideTabBarKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var hideTabBar: Bool {
        get { self[HideTabBarKey.self] }
        set { self[HideTabBarKey.self] = newValue }
    }
}

extension View {
    func hideTabBar(_ hide: Bool) -> some View {
        environment(\.hideTabBar, hide)
    }
}
