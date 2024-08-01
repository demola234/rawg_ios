//
//  CustomBotton.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 25/07/2024.
//

import SwiftUI

struct CustomButton: View {
    var action: () -> Void
    var title: String
    var isEnable: Bool = true
    var imageName: String? = nil
    var backgroundColor: Color
    var borderColor: Color? = Color.clear
    var textColor: Color = .theme.textFieldColor
    
    var body: some View {
        Button(action: isEnable ? action : {}) {
            HStack {
                if let imageName = imageName {
                    Image(imageName)
                        .font(.headline)
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                
                Text(title)
                    .customFont(CustomFont.orbitronBold.copyWith(size: 13))
                    .fontWeight(.bold)
                    .foregroundColor(isEnable ? textColor : .theme.background)
            }
            .padding(EdgeInsets(top: 12, leading: 10, bottom: 12, trailing: 10))
            .frame(width: 400, height: 45)
            .background(isEnable ? backgroundColor : Color.theme.accentTextColor)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor ?? Color.clear, lineWidth: 1) // Use Color.clear if borderColor is nil
            )
        }
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomButton(action: {}, title: "Create Account with Email", imageName: nil, backgroundColor: .black)
                .previewLayout(.sizeThatFits)
                .padding()
                .preferredColorScheme(.light)
            
            CustomButton(action: {}, title: "Create Account with Email", imageName: nil, backgroundColor: .black, borderColor: nil)
                .previewLayout(.sizeThatFits)
                .padding()
                .preferredColorScheme(.dark)
        }
    }
}
