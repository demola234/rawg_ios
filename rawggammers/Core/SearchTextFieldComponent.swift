//
//  SearchTextFieldComponent.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 03/08/2024.
//

import SwiftUI

/// `SearchTextFieldComponent` is a customizable SwiftUI view for search input. It features a search icon, a text field with placeholder, and a clear button.
/// It supports custom animations and can execute a callback when the user submits the search query.
struct SearchTextFieldComponent: View {
    
    // MARK: - Properties
    
    /// A binding to the search text. This property is updated as the user types in the text field.
    @Binding var text: String
    
    /// The placeholder text displayed when the text field is empty.
    var placeholder: String
    
    /// The label displayed above the text field.
    var label: String
    
    /// The type of keyboard to display. Default is `.default`.
    var keyboardType: UIKeyboardType = .default
    
    /// A closure to execute when the user submits the search query (presses "return" on the keyboard).
    var onCommit: () -> Void = {}
    
    /// The current color scheme of the environment. Used to adjust styling based on dark or light mode.
    @Environment(\.colorScheme) var colorScheme
    
    /// State to manage focus on the text field.
    @FocusState private var isFocused: Bool
    
    // Shorter duration for the underline animation.
    private let underlineAnimation = Animation.easeInOut(duration: 0.1)
    
    // MARK: - Initialization
    
    init(text: Binding<String>, placeholder: String, label: String, keyboardType: UIKeyboardType = .default, onCommit: @escaping () -> Void) {
        self._text = text
        self.placeholder = placeholder
        self.label = label
        self.onCommit = onCommit
        self.keyboardType = keyboardType
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .foregroundColor(Color.theme.primaryTextColor)
                .customFont(CustomFont.poppinsRegualr.copyWith(size: 14))
                .transition(.opacity)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.theme.accentTextColor)
                    .padding(.leading, 20)
                    .transition(.opacity)
                
                TextField("", text: $text, onCommit: {
                    onCommit()
                })
                .textFieldStyle(PlainTextFieldStyle())
                .placeholder(when: text.isEmpty, placeholder: Text(placeholder))
                .foregroundColor(Color.theme.primaryTextColor)
                .customFont(CustomFont.poppinsRegualr.copyWith(size: 14))
                .padding(12)
                .keyboardType(keyboardType)
                .autocapitalization(.none)
                .padding(.trailing, 10)
                .focused($isFocused)
                .cornerRadius(10)
                .transition(.opacity)
                
                if !text.isEmpty {
                    Button(action: {
                        withAnimation {
                            text = ""
                        }
                    }) {
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.theme.primaryTextColor)
                            .padding(.trailing, 20)
                    }
                    .transition(.opacity)
                }
            }
            
            // Underline below the TextField
            Color.theme.background
                .overlay(
                    isFocused ? Color.theme.primaryTextColor : Color.clear,
                    alignment: .bottom
                )
                .frame(height: 1)
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .offset(y: isFocused ? -1 : 0)
                .animation(underlineAnimation, value: isFocused)
        }
        .padding(.horizontal)
        .animation(.easeInOut, value: text.isEmpty)
    }
}

// MARK: - Preview

#Preview {
    SearchTextFieldComponent(text: .constant("Search in Rawg"), placeholder: "Search", label: "Search", keyboardType: .default) {}
}
