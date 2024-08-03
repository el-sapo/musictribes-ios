//
//  ViewExtensions.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 20/6/24.
//

import SwiftUI

extension Text {
    public func myFont(style: MyFontStyle = .regular, size: CGFloat = 16.0) -> some View {
        modifier(MyFont(size: size, style: style))
    }

}

extension View {
    public func myAnimatedGlow(color: Color) -> some View {
        modifier(MyAnimatedGlow())
    }

    public func myTribesGlow(color: Color) -> some View {
        modifier(MyTribesGlow())
    }

}
