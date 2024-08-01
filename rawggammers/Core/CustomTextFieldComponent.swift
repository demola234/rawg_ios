//
//  CustomTextFieldComponent.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 25/07/2024.
//
import SwiftUI

struct CustomTextFieldComponent: View {
    @Binding var text: String
    @State private var isObscured: Bool
    var placeholder: String
    var imageName: String
    var isSecure: Bool
    var label: String
    var border: Bool = false
    var keyboardType: UIKeyboardType = .default
    @Environment(\.colorScheme) var colorScheme
    
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
 
