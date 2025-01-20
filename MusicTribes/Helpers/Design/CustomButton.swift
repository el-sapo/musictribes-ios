//
//  CustomButton.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 19/6/24.
//

import SwiftUI

struct MyButtonStyle: PrimitiveButtonStyle {
    @State private var isPressed = false

    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .opacity(isPressed ? 0.6 : 1.0)
            .scaleEffect(isPressed ? 3.0 : 1.0)
            .animation(.spring(), value: isPressed)
            .onLongPressGesture(
                minimumDuration: 0,
                perform: {
                    // Trigger the button action
                    configuration.trigger()

                    // Animate the press effect
                    withAnimation(.spring()) {
                        isPressed = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isPressed = false
                        }
                    }
                }
            )
    }
}

struct CustomButton: View {
    let title: String
    let action: () -> Void
    let backgroundColor: Color
    let borderColor: Color
    let cornerRadius: CGFloat
    let textColor: Color
    let font: Font

    init(_
        title: String,
        action: @escaping () -> Void = {},
        backgroundColor: Color = Color.clear,
        borderColor: Color = Color.customOrange,
        cornerRadius: CGFloat = 15,
        textColor: Color = Color.customOrange,
        font: Font = .headline
    ) {
        self.title = title
        self.action = action
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.cornerRadius = cornerRadius
        self.textColor = textColor
        self.font = font
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(font)
                .foregroundColor(textColor)
                .padding()
                .multilineTextAlignment(.center)           
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: 2)
                )
        }
        .padding([.leading, .trailing], 20) // Add padding around the button if needed
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton("Another Button"
                    )
    }
}
