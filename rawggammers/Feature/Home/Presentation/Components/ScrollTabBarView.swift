//
//  ScrollTabBarView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 28/07/2024.
//

import SwiftUI

/// A view that displays a horizontally scrollable tab bar with selectable tabs.
///
/// This view is used to navigate between different sections of content in the app by selecting different tabs.
/// The selected tab updates the `selectedTab` binding and triggers a tab change in the `HomeViewModel`.
struct ScrollTabBarView: View {
    /// A binding to the currently selected tab.
    @Binding var selectedTab: Tab
    
    /// An array of widths for the text of each tab.
    @State private var textWidths: [CGFloat] = Array(repeating: 0, count: Tab.allCases.count)
    
    /// An environment object providing the `HomeViewModel` for managing tab selection.
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

/// Enumeration representing different tabs in the `ScrollTabBarView`.
enum Tab: String, CaseIterable {
    case trending = "Trending"
    case lastDays = "Last 30 days"
    case thisWeek = "This week"
    case nextWeek = "Next week"
}
