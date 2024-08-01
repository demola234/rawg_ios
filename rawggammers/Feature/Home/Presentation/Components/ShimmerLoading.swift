//
//  ShimmerLoading.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 01/08/2024.
//

import SwiftUI

struct ShimmerView: View {
    @Binding var isAnimating: Bool

    var body: some View {
        ZStack {
            Color.gray.opacity(0.3) // Base color of the placeholder
            Color.white.opacity(0.6) // Shimmer color
                .mask(
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.clear, .white, .clear]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .rotationEffect(.degrees(30))
                        .offset(x: isAnimating ? 300 : -300)
                )
                .onAppear {
                    withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                        isAnimating = true
                    }
                }
        }
    }
}

#Preview {
    ShimmerView(isAnimating: .constant(true))
}


struct ShimmerGameCardView: View {
    @Binding var isAnimating: Bool
    var body: some View {
        ZStack {
            ShimmerView(isAnimating: $isAnimating)
                .cornerRadius(20)
                .frame(width: 210, height: 250)
                .overlay(alignment: .bottom) {
                    UnevenRoundedRectangle(bottomLeadingRadius: 20, bottomTrailingRadius: 20)
                        .foregroundColor(.gray.opacity(0.3))
                        .frame(height: 93)
                        .overlay {
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    ForEach(0..<5) { _ in
                                        ShimmerView(isAnimating: $isAnimating)
                                            .frame(width: 15, height: 15)
                                            .cornerRadius(2)
                                    }
                                    Spacer()
                                    ShimmerView(isAnimating: $isAnimating)
                                        .frame(width: 35, height: 35)
                                        .cornerRadius(5)
                                }
                                .padding(.horizontal, 10)
                                .frame(maxWidth: 200, alignment: .leading)
                                
                                ShimmerView(isAnimating: $isAnimating)
                                    .frame(width: 180, height: 20)
                                    .cornerRadius(5)
                                    .padding(.horizontal, 10)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                        }
                }
        }
        .background(Color.theme.cardColor)
        .cornerRadius(20)
    }
}
