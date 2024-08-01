//
//  CustomTabView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 01/08/2024.
//

import SwiftUI

struct CustomTabView: View {
    @Binding var selectedTab: String
    @State var tabPoints: [CGFloat] = []
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarView(image: "home", selectedTab: $selectedTab, tabPoints: $tabPoints)
            TabBarView(image: "search", selectedTab: $selectedTab, tabPoints: $tabPoints)
            TabBarView(image: "favorite", selectedTab: $selectedTab,tabPoints: $tabPoints)
            TabBarView(image: "home", selectedTab: $selectedTab, tabPoints: $tabPoints)
        }
        .padding()
        .background(Color.theme.background.clipShape(TabCurve(tabPoint: getCurvePoint() - 15)))
        .overlay (
            Circle()
                .fill(Color.theme.background)
                .frame(width: 10, height: 10)
                .offset(x: getCurvePoint() - 20)
            , alignment: .bottomLeading
        )
        .cornerRadius(20)
        .padding(.horizontal)
    }
    
    func getCurvePoint() -> CGFloat {
        if tabPoints.isEmpty {
            return 10
        } else {
            switch selectedTab {
            case "home":
                return tabPoints[0]
            case "search":
                return tabPoints[1]
            case "favorite":
                return tabPoints[2]
            default:
                return 10
            }
        }    }
}

#Preview {
    CustomTabView(selectedTab: .constant("home"))
    
}


struct TabBarView: View {
    var image: String
    @Binding var selectedTab: String
    @Binding var tabPoints: [CGFloat]
    var body: some View {
        GeometryReader { reader -> AnyView in
            let midX = reader.frame(in: .global).midX
            
            DispatchQueue.main.async {
                if tabPoints.count <= 4 {
                    tabPoints.append(midX)
                }
            }
            return AnyView(
            Button(action: {
                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.5, blendDuration: 0.5)) {
                    selectedTab = image
                }
            }, label: {
                Image(systemName: image)
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundColor(Color.theme.accentTextColor)
                    .offset(y: selectedTab == image ? -10 : 0)
                
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            )
        }
        .frame(height: 90)
    }
}
