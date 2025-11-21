//
//  SolidusFadeOverlay.swift
//  SolidusApp
//
//  Created by racecar on 11/18/25.
//

import SwiftUI

struct SolidusFadeOverlay: View {
    enum EdgePosition { case top, bottom }
    let edge: EdgePosition
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: gradientColors),
            startPoint: edge == .top ? .top : .bottom,
            endPoint: edge == .top ? .bottom : .top
        )
        .allowsHitTesting(false)
    }
    
    private var gradientColors: [Color] {
        if colorScheme == .light {
            return edge == .top
                ? [Color.white.opacity(0.8), Color.white.opacity(0.0)]
                : [Color.white.opacity(0.0), Color.white.opacity(0.7)]
        } else {
            return edge == .top
                ? [Color.black.opacity(0.6), Color.black.opacity(0.0)]
                : [Color.black.opacity(0.0), Color.black.opacity(0.6)]
        }
    }
}
