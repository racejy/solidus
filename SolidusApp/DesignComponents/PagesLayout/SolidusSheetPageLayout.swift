//
//  SolidusSheetPageLayout.swift
//  SolidusApp
//
//  Created by racecar on 11/20/25.
//

import SwiftUI

struct SolidusSheetPage<Content: View, Bottom: View>: View {

    @Environment(\.dismiss) private var dismiss

    let title: String
    let content: () -> Content
    let bottomButton: () -> Bottom

    init(
        title: String,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder bottomButton: @escaping () -> Bottom
    ) {
        self.title = title
        self.content = content
        self.bottomButton = bottomButton
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {

                // BACKGROUND
                SolidusBackground()
                    .ignoresSafeArea()

                // MAIN SCROLL AREA
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {

                        // Header spacing
                        Spacer().frame(height: SolidusHeaderLayout.headerTopPadding - 60)

                        // Page Content
                        content()
                            .padding(.horizontal, 24)

                        // Bottom spacing
                        Spacer().frame(height: SolidusBottomLayout.bottomPadding)
                    }
                }

                // FIXED BOTTOM BUTTON
                VStack {
                    Spacer()
                    bottomButton()
                        .padding(.horizontal, SolidusBottomLayout.bottomOffset)
                        .padding(.bottom, SolidusBottomLayout.bottomPadding - 20)
                }
                .ignoresSafeArea()
            }

            // SYSTEM TOOLBAR
            .toolbar {

                // SYSTEM X BUTTON
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                }

                // CENTERED TITLE
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(SolidusHeaderLayout.titleFont)
                        .foregroundColor(.primary)
                }
            }
            .toolbarTitleDisplayMode(.inline)
        }
    }
}
