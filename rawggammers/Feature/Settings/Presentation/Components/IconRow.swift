//
//  IconRow.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 21/08/2024.
//

import SwiftUI

struct IconRow: View {
    public let icon: Icon
    @EnvironmentObject var appIconManager: AppIconManager
    
    var body: some View {
        VStack(alignment: .center) {
            
            VStack {
                Image(uiImage: icon.image ?? UIImage())
                    .resizable()
                    .frame(width: 60, height: 60)
                    .cornerRadius(10)
            }
            .overlay(
                Group {
                    if appIconManager.currentIconName == icon.iconName {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.theme.primaryTextColor, lineWidth: 2)
                            .padding(-3)
                    } else {
                        EmptyView() // No overlay if the condition is not met
                    }
                }
            )
            Text(icon.displayName)
                .foregroundStyle(Color.theme.primaryTextColor)
                .customFont(CustomFont.poppinsRegualr.copyWith(size: 15))
                .frame(width: 80, height: 30, alignment: .center)
                .background(Color.theme.cardColor, in: RoundedRectangle(cornerRadius: 10.0))
                .padding(.vertical, 10)
        }
        .padding(8)
    }
}

