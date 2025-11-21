//
//  SolidusFullPageLayout.swift
//  SolidusApp
//
//  Created by racecar on 11/20/25.
//

import SwiftUI

struct SolidusFullPage<Content: View>: View {
    let title: String
    let content: () -> Content

    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    var body: some View {
        ZStack(alignment: .top) {

            // BACKGROUND
            SolidusBackground()
                .ignoresSafeArea()

            // HEADER
            SolidusTopHeader(title: title)
                .padding(.top, SolidusHeaderLayout.headerTopPadding)
                .padding(.horizontal, SolidusHeaderLayout.horizontalPadding)
                .zIndex(10)

            // MAIN SCROLL CONTENT
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {

                    // TOP SPACER
                    Spacer().frame(height: SolidusHeaderLayout.headerTopPadding + 20)

                    // PAGE CONTENTS
                    content()
                        .padding(.horizontal, 8)

                    // BOTTOM SPACER
                    Spacer().frame(height: SolidusBottomLayout.bottomPadding)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .ignoresSafeArea(edges: .top)
    }
}
