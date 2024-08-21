//
//  BottomSheetView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 20/08/2024.
//

import SwiftUI

struct BottomSheetView<Content: View>: View {
        @Binding var show: Bool
        @Binding var offset: CGFloat
        let content: Content
        let height: CGFloat
        
        init(show: Binding<Bool>, offset: Binding<CGFloat>, height: CGFloat, @ViewBuilder content: () -> Content) {
            self._show = show
            self._offset = offset
            self.height = height
            self.content = content()
        }
        
        var body: some View {
            VStack {
                Capsule()
                    .frame(width: 40, height: 6)
                    .foregroundColor(Color.gray.opacity(0.6))
                    .padding(.top, 8)
                Spacer()
                
                content
                    .padding(.top)
                    .padding(.horizontal, 20)
            }
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(Color.theme.background)
            .cornerRadius(20)
            .shadow(radius: 20)
            .transition(.move(edge: .bottom))
            .offset(y: show ? UIScreen.main.bounds.height / 4 : UIScreen.main.bounds.height)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.height > 0 {
                            offset = value.translation.height
                        }
                    }
                    .onEnded { value in
                        if value.translation.height > 100 {
                            withAnimation {
                                show = false
                            }
                        }
                        offset = 0
                    }
            )
        }
    }

#Preview {
    BottomSheetView(show: .constant(true), offset: .constant(0), height: 300) {
        VStack {
            Text("Preview Content")
                .font(.headline)
                .padding()
            
            Button("Action") {
                print("Button tapped!")
            }
            .padding()
        }
    }
}
