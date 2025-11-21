//
//  SolidusHeaderLayout.swift
//  SolidusApp
//
//  Created by racecar on 11/18/25.
//

import SwiftUI

enum SolidusHeaderLayout {
    
    // TOP SPACING
    static let horizontalPadding: CGFloat = 12
    static let topOffset: CGFloat = 4
    
    // TITLE
    static var titleFont: Font {
        .system(size: 20, weight: .semibold)
    }
    
    static var safeAreaTop: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?
            .safeAreaInsets.top ?? 0
    }
    
    static var headerTopPadding: CGFloat {
        safeAreaTop + topOffset
    }
}
