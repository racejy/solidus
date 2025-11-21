//
//  SolidusRounded.swift
//  Solidus
//
//  Created by racecar on 11/18/25.
//

import SwiftUI

// Rectangle Rounded style
struct SolidusRoundedModifier: ViewModifier {
    var radius: CGFloat
    var shadowOpacity: Double
    var shadowRadius: CGFloat
    var shadowY: CGFloat
    
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .shadow(color: .black.opacity(shadowOpacity),
                    radius: shadowRadius,
                    y: shadowY)
    }
}

// Circle rounded
struct SolidusCircleModifier: ViewModifier {
    var shadowOpacity: Double
    var shadowRadius: CGFloat
    var shadowY: CGFloat
    
    func body(content: Content) -> some View {
        content
            .clipShape(Circle())
            .shadow(color: .black.opacity(shadowOpacity),
                    radius: shadowRadius,
                    y: shadowY)
    }
}

extension View {
    func solidusRounded(
        radius: CGFloat = 20,
        shadowOpacity: Double = 0.10,
        shadowRadius: CGFloat = 12,
        shadowY: CGFloat = 6
    ) -> some View {
        self.modifier(
            SolidusRoundedModifier(
                radius: radius,
                shadowOpacity: shadowOpacity,
                shadowRadius: shadowRadius,
                shadowY: shadowY
            )
        )
    }
    
    func solidusCircle(
        shadowOpacity: Double = 0.10,
        shadowRadius: CGFloat = 12,
        shadowY: CGFloat = 6
    ) -> some View {
        self.modifier(
            SolidusCircleModifier(
                shadowOpacity: shadowOpacity,
                shadowRadius: shadowRadius,
                shadowY: shadowY
            )
        )
    }
}
