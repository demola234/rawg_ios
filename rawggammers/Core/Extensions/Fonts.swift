//
//  Fonts.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 25/07/2024.
//
import Foundation
import SwiftUI

struct CustomFont {
    var name: String
    var size: CGFloat
    var fontWeight: Font.Weight
    
    func font() -> Font {
        return Font.custom(name, size: size)
    }
    
    func copyWith(size: CGFloat? = nil) -> CustomFont {
        return CustomFont(name: self.name, size: size ?? self.size, fontWeight: self.fontWeight)
    }
}

extension CustomFont {
    static let orbitronNormal = CustomFont(name: "Orbitron", size: 100, fontWeight: .regular)
    static let orbitronBold = CustomFont(name: "Orbitron-Bold", size: 12, fontWeight: .bold)
    static let orbitronBlack = CustomFont(name: "Orbitron-Black", size: 12, fontWeight: .black)
    static let orbitronMedium = CustomFont(name: "Orbitron-Medium", size: 12, fontWeight: .medium)
    static let orbitronRegular = CustomFont(name: "Orbitron-Regular", size: 12, fontWeight: .regular)
    static let orbitronSemiBold = CustomFont(name: "Orbitron-SemiBold", size: 12, fontWeight: .semibold)
    static let poppinsBold = CustomFont(name: "Poppins-Bold", size: 12, fontWeight: .bold)
    static let poppinsExtraBold = CustomFont(name: "Poppins-ExtraBold", size: 12, fontWeight: .heavy)
    static let poppinsExtraLight = CustomFont(name: "Poppins-ExtraLight", size: 12, fontWeight: .ultraLight)
    static let poppinsRegualr = CustomFont(name: "Poppins-Medium", size: 12, fontWeight: .regular)
}

struct CustomFontModifier: ViewModifier {
    var customFont: CustomFont
    
    func body(content: Content) -> some View {
        content.font(customFont.font())
    }
}

extension View {
    func customFont(_ customFont: CustomFont) -> some View {
        self.modifier(CustomFontModifier(customFont: customFont))
    }
}
