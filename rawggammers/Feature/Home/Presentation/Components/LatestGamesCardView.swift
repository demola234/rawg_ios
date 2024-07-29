//
//  LatestGamesCardView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 28/07/2024.
//
import SwiftUI

struct LatestGamesCardView: View {
    var body: some View {
        ZStack {
            Image("Games")
                .resizable()
                .scaledToFill()
                .frame(width: 400, height: 230)
                .clipped()
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .overlay(
                    VStack {
                        Spacer()
                        HStack {
                            Text("Vampire: The Masquerade - Bloodlines 2")
                                .font(
                                    Font.custom("Orbitron", size: 14)
                                        .weight(.bold)
                                )
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                            
                            Spacer()
                            
                            HStack(spacing: 5) {
                                Image("ps")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Image("windows")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Image("xbox")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                        }
                        .frame(height: 80)
                        .background(Color.black)
                        .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
                    }
                )
        }
        .frame(width: 400, height: 230)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

#Preview {
    LatestGamesCardView()
        .previewLayout(.sizeThatFits)
}
