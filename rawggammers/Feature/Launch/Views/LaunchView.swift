//
//  LaunchView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 25/07/2024.
//
import SwiftUI

struct LaunchView: View {
    @State private var rawgLogo: [String] = "RAWG".map { String($0) }
    @State private var showLoadingText: [Bool] = Array(repeating: false, count: "RAWG".count)
    @State private var bounceUp: Bool = false
    @Binding var showLaunchView: Bool
    
    var body: some View {
        ZStack {
            Color.launch.background
                .ignoresSafeArea()
            
                HStack(spacing: 0) {
                    ForEach(rawgLogo.indices, id: \.self) { index in
                        Text(rawgLogo[index])
                            .customFont(CustomFont.orbitronBold.copyWith(size: 35))
                            .tracking(7)
                            .fontWeight(.heavy)
                            .foregroundColor(Color.launch.launchText)
                            .opacity(showLoadingText[index] ? 1 : 0)
                            .offset(y: bounceUp ? -50 : 0)
                            .animation(.easeIn(duration: 0.5).delay(Double(index) * 0.2), value: showLoadingText[index])
                            .animation(.interpolatingSpring(stiffness: 50, damping: 5).delay(Double(rawgLogo.count) * 0.2), value: bounceUp)
                    }
                }
                .padding(.top, 50)
                .offset(y: 50)
            }
        .onAppear {
            animateText()
        }
    }
    
    func animateText() {
        for index in rawgLogo.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.2) {
                showLoadingText[index] = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(rawgLogo.count) * 0.2 + 0.5) {
            withAnimation {
                bounceUp = true
            }
        }
//        toogle showLaunchView to false after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            showLaunchView = false
        }
    }
}

#Preview {
    LaunchView(showLaunchView: .constant(true))
}
