//
//  SolidusIconButton.swift
//  Solidus
//
//  Created by racecar on 11/18/25.
//

import SwiftUI

struct SolidusIconButtonStyle: ViewModifier {
    let size: CGFloat
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: .bold))
            .foregroundColor(color)
            .frame(width: size + 20, height: size + 20)  // 44 for size 24, etc
            .contentShape(Rectangle())
    }
}

extension View {
    func solidusIconButton(size: CGFloat, color: Color) -> some View {
        self.modifier(SolidusIconButtonStyle(size: size, color: color))
    }
}
