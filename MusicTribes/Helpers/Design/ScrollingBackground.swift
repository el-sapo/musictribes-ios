//
//  ScrollingBackground.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 30/7/24.
//

import SwiftUI

struct ScrollingBackground: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ForEach(0..<Int(geometry.size.height / UtilDimensions.screenHeight) + 1, id: \.self) { _ in
                    Image("woo-back-1")
                        .resizable()
                        .scaledToFill()
                        .frame(width: UtilDimensions.screenHeight, height: UtilDimensions.screenHeight)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ScrollingBackground()
}
