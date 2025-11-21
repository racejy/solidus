//
//  SolidusAnimation.swift
//  Solidus
//
//  Created by racecar on 11/18/25.
//

import SwiftUI

enum SolidusAnimation {
    // Clean, modern, minimal spring
    static let smooth = Animation.spring(
        response: 0.28,
        dampingFraction: 0.90,
        blendDuration: 0.1
    )
    
    // Very subtle tap animation for small UI interactions
    static let tap = Animation.spring(
        response: 0.22,
        dampingFraction: 0.88
    )
}
