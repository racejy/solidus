//
//  SolidusFABLayout.swift
//  Solidus
//
//  Created by racecar on 11/18/25.
//

import SwiftUI

enum SolidusFABLayout {
    
    // FAB Button Layout
    static let fabButtonSize: CGFloat = 60
    static let fabTrailingPadding: CGFloat = 24
    static let fabBottomPadding: CGFloat = 6     // below the FAB
    
    // FAB Menu Layout
    static var fabMenuVerticalOffset: CGFloat {
        fabButtonSize + 24   // spacing above FAB Button
    }
    
    static let fabMenuItemSpacing: CGFloat = 16 // spacing in between FAB items
}
