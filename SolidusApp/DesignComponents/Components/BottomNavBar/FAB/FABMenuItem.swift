//
//  FABMenuItem.swift
//  Solidus
//
//  Created by racecar on 11/18/25.
//

import SwiftUI

struct FABMenuItem: View {
    @Environment(\.colorScheme) var colorScheme
    
    var icon: String
    var label: String
    var action: () -> Void
    
    // WHITE CIRCLE
    private var circleBackground: Color {
        .white
    }
    
    private var labelColor: Color {
        .white.opacity(0.95)
    }
    
    private var iconColor: Color {
        Color.backgroundTeal
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                
                Text(label)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(labelColor)
                
                ZStack {
                    Circle()
                        .fill(circleBackground)
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(iconColor)
                }
            }
            .padding(.trailing, 4)
        }
    }
}
