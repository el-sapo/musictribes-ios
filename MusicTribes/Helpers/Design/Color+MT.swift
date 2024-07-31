//
//  Color+MT.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 6/6/24.
//

import Foundation
import SwiftUI

extension Color {
    static let customOrange = Color(red: 0.96, green: 0.38, blue: 0.2) // #F46133
    static let customGreen = Color(red: 0.588, green: 0.58, blue: 0.333)
    static let customCream = Color(red: 0.96, green: 0.88, blue: 0.81)
    static let sand = Color(hex: "#ffeac2")
    static let water = Color(hex: "#206a82")
    static let clearWater = Color(hex: "#91eff6")
    static let sunset = Color(hex: "#ff9c3e")

    static let scene1 = Color(hex: "#0f91b3")
    static let scene2 = Color(hex: "#6cc8b3")
    static let scene3 = Color(hex: "#944cb0")
    static let scene4 = Color(hex: "#b6a44e")
    static let scene5 = Color(hex: "#dc650f")
    static let scene6 = Color(hex: "#dc949f")
}

struct ColorScheme {
    let primary: Color
    let secondary: Color
    let alternative: Color
}

enum BackgroundColorsStyle {
    case dark
    case beach
    
    func colorScheme() -> ColorScheme {
            switch self {
            case .dark:
                return ColorScheme(
                    primary: .black,
                    secondary: .customOrange,
                    alternative: .customGreen
                )
            case .beach:
                return ColorScheme(
                    primary: .sand,
                    secondary: .customGreen,
                    alternative: .sunset
                )
            }
        }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8 * 17), (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
