//
//  SolidusSearchBar.swift
//  SolidusApp
//
//  Created by racecar on 11/19/25.
//

import SwiftUI

struct SolidusSearchBar: View {
    @Binding var text: String
    var placeholder: String
    
    @Environment(\.colorScheme) private var scheme
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .font(.system(size: 18))

            TextField(placeholder, text: $text)
                .foregroundColor(.primary)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .background(
            SolidusGlass(
                color: scheme == .light ? .white : .black,
                opacity: scheme == .light ? 0.06 : 0.12
            )
        )
        .solidusRounded(
            radius: 20,
            shadowOpacity: 0.10,
            shadowRadius: 6,
            shadowY: 3
        )
    }
}
