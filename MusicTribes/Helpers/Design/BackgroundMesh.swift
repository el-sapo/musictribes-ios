//
//  BackgroundMesh.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 18/6/24.
//

import SwiftUI


struct BackgroundGradient: View {
    let colorScheme: ColorScheme

    init(colorScheme: ColorScheme = BackgroundColorsStyle.dark.colorScheme()) {
        self.colorScheme = colorScheme
    }

    var body: some View {
        Group {
            if #available(iOS 18.0, *) {
                BackgroundMesh(colorScheme: colorScheme)
            } else {
                // Provide a fallback view for iOS versions earlier than 17
                Color.black // Example fallback view
            }
        }
    }
}

@available(iOS 18.0, *)
struct BackgroundMesh: View {
    @State var t: Float = 0.0
    @State var timer: Timer?
    
    let colorScheme: ColorScheme

    var cColor: Color { return colorScheme.alternative }
    var aColor: Color { return colorScheme.primary }
    var bColor: Color { return colorScheme.secondary }

    init(colorScheme: ColorScheme = BackgroundColorsStyle.dark.colorScheme()) {
        self.colorScheme = colorScheme
    }

    var body: some View {
        MeshGradient(width: 3, height: 3, points: [
                   .init(0, 0), .init(0.5, 0), .init(1, 0),
                   [sinInRange(-0.8...(-0.2), offset: 0.439, timeScale: 0.342, t: t), sinInRange(0.3...0.7, offset: 3.42, timeScale: 0.984, t: t)],
                   [sinInRange(0.1...0.8, offset: 0.239, timeScale: 0.084, t: t), sinInRange(0.2...0.8, offset: 5.21, timeScale: 0.242, t: t)],
                   [sinInRange(1.0...1.5, offset: 0.939, timeScale: 0.084, t: t), sinInRange(0.4...0.8, offset: 0.25, timeScale: 0.642, t: t)],
                   [sinInRange(-0.8...0.0, offset: 1.439, timeScale: 0.442, t: t), sinInRange(1.4...1.9, offset: 3.42, timeScale: 0.984, t: t)],
                   [sinInRange(0.3...0.6, offset: 0.339, timeScale: 0.784, t: t), sinInRange(1.0...1.2, offset: 1.22, timeScale: 0.772, t: t)],
                   [sinInRange(1.0...1.5, offset: 0.939, timeScale: 0.056, t: t), sinInRange(1.3...1.7, offset: 0.47, timeScale: 0.342, t: t)]
               ], colors: [
                bColor, aColor, bColor,
                aColor, aColor, aColor,
                bColor, aColor, cColor
               ])
               .background(.black)
               .onAppear {
                   timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
                       t += 0.06
                   }
               }
    }
    
    func sinInRange(_ range: ClosedRange<Float>, offset: Float, timeScale: Float, t: Float) -> Float {
        let amplitude = (range.upperBound - range.lowerBound) / 2
        let midPoint = (range.upperBound + range.lowerBound) / 2
        return midPoint + amplitude * sin(timeScale * t + offset)
    }
}
