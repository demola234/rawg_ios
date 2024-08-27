//
//  CustomTextFieldComponent.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 25/07/2024.
//

import SwiftUI

/// `CustomTextFieldComponent` is a reusable SwiftUI component that provides a stylized text field
/// with support for secure text entry, placeholder text, icons, and custom labeling.
/// It is designed to work seamlessly in both light and dark modes.
struct CustomTextFieldComponent: View {
    
    // MARK: - Properties
    
    /// Binding to the text entered in the text field.
    @Binding var text: String
    
    /// State to track whether the text is obscured (for secure input fields).
    @State private var isObscured: Bool
    
    /// Placeholder text displayed when the text field is empty.
    var placeholder: String
    
    /// Name of the system image displayed at the start of the text field.
    var imageName: String
    
    /// Boolean indicating if the text field is for secure input (e.g., passwords).
    var isSecure: Bool
    
    /// Label displayed above the text field.
    var label: String
    
    /// Boolean indicating if the text field should have a border.
    var border: Bool = false
    
    /// The keyboard type to use for the text field (e.g., email, number pad).
    var keyboardType: UIKeyboardType = .default
    
    /// The current color scheme (light or dark mode) of the environment.
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Initializer
    
    /// Initializes a new instance of `CustomTextFieldComponent`.
    ///
    /// - Parameters:
    ///   - text: Binding to the text entered in the text field.
    ///   - placeholder: Placeholder text displayed when the text field is empty.
    ///   - imageName: Name of the system image displayed at the start of the text field.
    ///   - isSecure: Boolean indicating if the text field is for secure input.
    ///   - label: Label displayed above the text field.
    ///   - keyboardType: The keyboard type to use for the text field. Default is `.default`.
    ///   - border: Boolean indicating if the text field should have a border. Default is `false`.
    init(text: Binding<String>, placeholder: String, imageName: String, isSecure: Bool, label: String, keyboardType: UIKeyboardType = .default, border: Bool = false) {
        self._text = text
        self.placeholder = placeholder
        self.imageName = imageName
        self.isSecure = isSecure
        self._isObscured = State(initialValue: isSecure)
        self.label = label
        self.keyboardType = keyboardType
        self.border = border
    }
    
    // MARK: - Computed Views
    
    /// Returns a view representing the text field, which handles both secure and regular input.
    private var textField: some View {
        Group {
            if isSecure {
                if isObscured {
                    SecureField("", text: $text)
                } else {
                    TextField("", text: $text)
                }
            } else {
                TextField("", text: $text)
            }
        }
        .textFieldStyle(PlainTextFieldStyle())
        .placeholder(when: text.isEmpty, placeholder: Text(placeholder))
        .foregroundColor(Color.theme.primaryTextColor)
        .padding(12)
        .keyboardType(keyboardType)
        .autocapitalization(.none)
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .foregroundColor(Color.theme.primaryTextColor)
                .customFont(CustomFont.poppinsRegualr.copyWith(size: 14))
            
            HStack {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.theme.primaryTextColor)
                    .padding(.leading, 20)
                
                textField
                    .padding(.trailing, 10)
                
                if isSecure {
                    Button(action: {
                        isObscured.toggle()
                    }) {
                        Image(systemName: !isObscured ? "eye.slash" : "eye")
                            .foregroundColor(Color.theme.primaryTextColor)
                            .padding(.trailing, 12)
                    }
                }
            }
            .background(Color.theme.textFieldColor)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(colorScheme == .dark ? Color.clear : Color.theme.accentTextColor, lineWidth: border ? 1 : 0)
            )
        }
    }
}

// MARK: - Preview

#Preview {
    Group {
        CustomTextFieldComponent(text: .constant(""), placeholder: "Email address", imageName: "envelope", isSecure: false, label: "Email", border: true)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
            .padding()
        
        CustomTextFieldComponent(text: .constant(""), placeholder: "Password", imageName: "lock", isSecure: true, label: "Password", border: true)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
            .padding()
        
        CustomTextFieldComponent(text: .constant(""), placeholder: "Email address", imageName: "envelope", isSecure: false, label: "Email", border: true)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.light)
            .padding()
        
        CustomTextFieldComponent(text: .constant(""), placeholder: "Password", imageName: "lock", isSecure: true, label: "Password", border: true)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.light)
            .padding()
    }
}
