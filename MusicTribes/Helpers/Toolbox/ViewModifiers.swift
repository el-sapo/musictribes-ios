//
//  ViewModifiers.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 20/6/24.
//

import SwiftUI

public enum MyFontStyle {
    case big
    case bold
    case regular
    case light
}

struct MyFont: ViewModifier {
    var size: CGFloat
    var style: MyFontStyle

    var fontName: String {
        switch (self.style)  {
        case .big:
            return "Gotham-Black"
        case .bold:
            return "Gotham-Bold"
        case .regular:
            return "Gotham-Medium"
        case .light:
            return "Gotham-Light"
        }
    }

    init(size: CGFloat = 16.0, style: MyFontStyle = .regular) {
        self.size = size
        self.style = style
    }
    
    //  where we define how the modifier alters the provided content.
    func body(content: Content) -> some View {
        content
            .font(.custom(fontName,size: size))
    }
    
}

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
