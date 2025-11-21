//
//  SolidusPrimaryButton.swift
//  SolidusApp
//
//  Created by racecar on 11/19/25.
//

import SwiftUI

struct SolidusPrimaryButton: View {
    @Environment(\.colorScheme) private var scheme

    let title: String
    let action: () -> Void
    var isEnabled: Bool = true

    var body: some View {
        Button(action: {
            if isEnabled { action() }
        }) {
            HStack {
                Spacer()
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .padding(.vertical, 18)
                Spacer()
            }
            .background(Color("accent_mint"))
            .foregroundColor(.white)
            .cornerRadius(24)
            .shadow(
                color: scheme == .light
                    ? Color.black.opacity(0.10)
                    : Color.black.opacity(0.40),
                radius: 8,
                y: 4
            )
            .opacity(isEnabled ? 1.0 : 0.4)
        }
        .disabled(!isEnabled)
    }
}
