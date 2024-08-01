import SwiftUI

struct AuthButton: View {
    var action: () -> Void
    var isEnable: Bool = true
    var imageName: String? = nil
    var backgroundColor: Color = .theme.background
    var borderColor: Color? = Color.theme.accentTextColor
    var textColor: Color = .theme.accentTextColor
    
    var body: some View {
        Button(action: action) {
            HStack {
                if let imageName = imageName {
                    Image(imageName)
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                
            }
            .padding()
            .background(backgroundColor)
            .frame(width: 120, height: 50)
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(borderColor ?? Color.clear, lineWidth: 1)
            )
        }
        .disabled(!isEnable)
    }
}

#Preview {
    AuthButton(action: {}, imageName: "GoogleLogo")
        .previewLayout(.sizeThatFits)
        .padding()
        .preferredColorScheme(.light)
}
