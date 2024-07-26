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
    var keyboardType: UIKeyboardType = .default
    
    init(text: Binding<String>, placeholder: String, imageName: String, isSecure: Bool, label: String, keyboardType: UIKeyboardType = .default) {
        self._text = text
        self.placeholder = placeholder
        self.imageName = imageName
        self.isSecure = isSecure
        self._isObscured = State(initialValue: isSecure)
        self.label = label
        self.keyboardType = isSecure ? .default : .emailAddress
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
        .background(Color.theme.textFieldColor)
        .accentColor(Color.theme.accentTextColor)
        .cornerRadius(8)
        .autocapitalization(.none)
        .keyboardType(keyboardType)
        
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(label)
                .foregroundColor(Color.theme.accentTextColor)
                .customFont(CustomFont.poppinsRegualr.copyWith(size: 14))
            
            HStack {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.theme.accentTextColor)
                    .padding(.leading, 9)
                
                textField
                    .padding(.trailing, 12)
                
                if isSecure {
                    Button(action: {
                        isObscured.toggle()
                    }) {
                        Image(systemName: !isObscured ? "eye.slash" : "eye")
                            .foregroundColor(Color.theme.accentTextColor)
                            .padding(.trailing, 12)
                    }
                }
            }
            .background(Color.theme.textFieldColor)
            .cornerRadius(8)
        }
    }
}

#Preview {
    Group {
        CustomTextFieldComponent(text: .constant(""), placeholder: "Email address", imageName: "envelope", isSecure: false, label: "Email")
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
            .padding()
        
        CustomTextFieldComponent(text: .constant(""), placeholder: "Password", imageName: "lock", isSecure: true, label: "Password")
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
            .padding()
    }
}
