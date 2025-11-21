//
//  SolidusBackground.swift
//  SolidusApp
//
//  Created by racecar on 11/18/25.
//

import SwiftUI

struct SolidusBackground: View {
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        (scheme == .light ? Color.white : Color.black)
            .ignoresSafeArea()
    }
}
