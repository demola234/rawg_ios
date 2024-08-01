//
//  ScrollTabBarView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 28/07/2024.
//

import SwiftUI

struct ScrollTabBarView: View {
    @Binding var selectedTab: Tab
    @State private var textWidths: [CGFloat] = Array(repeating: 0, count: Tab.allCases.count)
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Tab.allCases.indices, id: \.self) { index in
                        let tab = Tab.allCases[index]
                        Text(tab.rawValue)
                            .customFont(CustomFont.poppinsRegualr.copyWith(size: 12))
                            .padding()
                            .background(
                                GeometryReader { textGeoWidth -> Color in
                                    DispatchQueue.main.async {
                                        textWidths[index] = textGeoWidth.size.width
                                    }
                                    return Color.clear
                                }
                            )
                            .id(index)
                            .frame(minWidth: textWidths.max() ?? 0, alignment: .center)
                            .foregroundColor(selectedTab == tab ? .theme.background : .theme.accentTextColor)
                            .background(selectedTab == tab ? Color.theme.primaryTextColor : Color.clear)
                            .overlay(
                                Capsule()
                                    .stroke(selectedTab == tab ? Color.clear : Color.gray, lineWidth: 1)
                            )
                            .clipShape(Capsule())
                            .onTapGesture {
                                withAnimation(.spring) {
                                    selectedTab = tab
                                    homeViewModel.selectNewTab(tab: selectedTab)
                                   
                                    
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation {
                                        proxy.scrollTo(index, anchor: .center)
                                    }
                                }
                            }
                    }
                }
                .padding(.horizontal, 10)
            }
            .onAppear {
                DispatchQueue.main.async {
                    textWidths = textWidths.map { $0 == 0 ? (textWidths.max() ?? 0) : $0 }
                }
        }
        }
    }
}

#Preview {
    ScrollTabBarView(selectedTab: .constant(.trending))
        .previewLayout(.sizeThatFits)
        .padding()
}

enum Tab: String, CaseIterable {
    case trending = "Trending"
    case lastDays = "Last 30 days"
    case thisWeek = "This week"
    case nextWeek = "Next week"
}
