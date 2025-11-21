//
//  SolidusBottomLayout.swift
//  SolidusApp
//
//  Created by racecar on 11/20/25.
//

import SwiftUI

enum SolidusBottomLayout {

    // BOTTOM SPACING
    static let bottomOffset: CGFloat = 28

    static var safeAreaBottom: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?
            .safeAreaInsets.bottom ?? 0
    }

    static var bottomPadding: CGFloat {
        safeAreaBottom + bottomOffset
    }
}
