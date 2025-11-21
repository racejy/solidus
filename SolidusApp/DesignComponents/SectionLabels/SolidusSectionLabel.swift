//
//  SolidusSectionLabel.swift
//  SolidusApp
//
//  Created by racecar on 11/19/25.
//

import SwiftUI

struct SolidusSectionLabel: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.secondary)
            .padding(.leading, 4)
    }
}
