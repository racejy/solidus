//
//  HamburgerMenuButton.swift
//  Solidus
//
//  Created by racecar on 11/18/25.
//

import SwiftUI

struct HamburgerMenuButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "line.3.horizontal")
                .solidusIconButton(size: 24, color: .primary)
        }
        .contentShape(Rectangle())
    }
}
