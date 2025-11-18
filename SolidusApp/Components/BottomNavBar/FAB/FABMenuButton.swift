//
//  FABMenuButton.swift
//  Solidus
//
//  Created by racecar on 11/18/25.
//

import SwiftUI

struct FABMenuButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .solidusIconButton(size: 24, color: .white)
                .frame(width: 60, height: 60)
                .background(Color.backgroundTeal)
                .solidusCircle(
                    shadowOpacity: 0.25,
                    shadowRadius: 12,
                    shadowY: 6
                )
        }
        .contentShape(Rectangle())
    }
}
