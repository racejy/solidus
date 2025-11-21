//
//  Glass.swift
//  Solidus
//
//  Created by racecar on 11/18/25.
//

import SwiftUI

struct SolidusGlass: View {
    var color: Color = .clear   // tint
    var opacity: Double = 0.35  // tint strength
    
    var body: some View {
        ZStack {
            // Base system blur
            Rectangle()
                .fill(.ultraThinMaterial)
            
            // Optional color tint (0 if clear)
            color.opacity(color == .clear ? 0 : opacity)
        }
    }
}
