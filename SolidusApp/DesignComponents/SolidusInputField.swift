//
//  SolidusInputField.swift
//  SolidusApp
//
//  Created by racecar on 11/18/25.
//

import SwiftUI

struct SolidusInputField<Content: View>: View {
    
    // Properties
    let label: String
    let icon: String?
    let content: Content
    
    @FocusState private var isFocused: Bool
    @Environment(\.colorScheme) private var scheme
    
    init(label: String, icon: String? = nil, @ViewBuilder content: () -> Content) {
        self.label = label
        self.icon = icon
        self.content = content()
    }
    
    // Body
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            // LABEL
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isFocused ? Color("background_teal") : .secondary)
                .padding(.leading, icon == nil ? 6 : 2)
                .animation(SolidusAnimation.smooth, value: isFocused)
            
            // FIELD + BACKGROUND
            HStack(spacing: 12) {
                
                // ICON
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color("background_teal"))
                        .frame(width: 24)
                }
                
                // CUSTOM FIELD CONTENT
                content
                    .focused($isFocused)
                    .font(.system(size: 16))
                    .padding(.vertical, 12)
            }
            .padding(.horizontal, 12)
            .background(fieldBackground)
            .solidusRounded(radius: 20, shadowOpacity: 0.10, shadowRadius: 8, shadowY: 3)
        }
        .padding(.vertical, 2)
    }
    
    // Background
    private var fieldBackground: some View {
        ZStack {
            // Blur base
            SolidusGlass(color: scheme == .light ? .white : .black.opacity(0.8),
                         opacity: scheme == .light ? 0.16 : 0.22)
            
            // Light highlight
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    scheme == .light
                    ? Color.white.opacity(0.25)
                    : Color.white.opacity(0.06)
                )
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
