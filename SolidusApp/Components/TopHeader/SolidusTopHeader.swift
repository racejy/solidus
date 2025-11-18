//
//  SolidusTopHeader.swift
//  SolidusApp
//
//  Created by racecar on 11/18/25.
//

import SwiftUI

struct SolidusTopHeader: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 22, weight: .semibold))
            .foregroundColor(.primary)
    }
}
