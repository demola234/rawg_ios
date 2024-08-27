//
//  HepticManager.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import Foundation
import SwiftUI

/// A manager class for handling haptic feedback using UIKit's haptic feedback generators.
class HepticManager {
    
    /// The shared instance of `HepticManager` for accessing its methods.
    static let shared = HepticManager()
    
    /// Triggers a notification feedback.
    ///
    /// This method uses `UINotificationFeedbackGenerator` to provide feedback for notifications like success, warning, or error.
    ///
    /// - Parameter type: The type of feedback to be generated. This can be `.success`, `.warning`, or `.error`.
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    /// Triggers an impact feedback.
    ///
    /// This method uses `UIImpactFeedbackGenerator` to provide feedback for physical impacts. Different styles can be used to simulate different types of impacts.
    ///
    /// - Parameter style: The style of impact feedback. Possible values are `.light`, `.medium`, `.heavy`, or `.soft`.
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    /// Triggers a selection feedback.
    ///
    /// This method uses `UISelectionFeedbackGenerator` to provide feedback for selection changes, typically used for UI elements like pickers.
    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    /// Prepares the haptic feedback generator for impact feedback with a heavy style.
    ///
    /// This method prepares a `UIImpactFeedbackGenerator` with a `.heavy` style to reduce the latency of the haptic feedback when it is triggered.
    func prepare() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
    }
    
    /// Prepares the haptic feedback generator for impact feedback with a light style.
    ///
    /// This method prepares a `UIImpactFeedbackGenerator` with a `.light` style to reduce the latency of the haptic feedback when it is triggered.
    func prepareLight() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
    }
    
    /// Prepares the haptic feedback generator for impact feedback with a medium style.
    ///
    /// This method prepares a `UIImpactFeedbackGenerator` with a `.medium` style to reduce the latency of the haptic feedback when it is triggered.
    func prepareMedium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
    }
    
    /// Prepares the haptic feedback generator for impact feedback with a soft style.
    ///
    /// This method prepares a `UIImpactFeedbackGenerator` with a `.soft` style to reduce the latency of the haptic feedback when it is triggered.
    func prepareSoft() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.prepare()
    }
}
