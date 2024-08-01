//
//  Toogle.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 31/07/2024.
//

import Foundation
import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Button(action: {
                configuration.isOn.toggle()
            }) {
               RoundedRectangle(cornerRadius: 3)
                    .frame(width: 20, height: 20)
                    .foregroundColor(configuration.isOn ? .theme.goldColor : .theme.background)
                    .background(configuration.isOn ? Color.theme.goldColor : Color.theme.background)
                    .cornerRadius(3)
                    .overlay(
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(Color.theme.primaryTextColor, lineWidth: 1)
                    )
                    
            }
            .buttonStyle(PlainButtonStyle())
            .animation(.easeInOut, value: configuration.isOn)
            .padding(.trailing, 5)
//            configuration.label
        }
    }
}
