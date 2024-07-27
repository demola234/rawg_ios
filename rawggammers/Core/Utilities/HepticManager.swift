//
//  HepticManager.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import Foundation
import SwiftUI


class HepticManager {
    static let shared = HepticManager()
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    func prepare() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
    }
    
    func prepareLight() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
    }
    
    func prepareMedium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
    }
    
    func prepareSoft() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.prepare()
    }
}
