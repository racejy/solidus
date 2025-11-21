//
//  SolidusSearchSheetPageLayout.swift
//  SolidusApp
//
//  Created by racecar on 11/20/25.
//

import SwiftUI

struct SolidusSearchSheetPage<Content: View, BottomBar: View>: View {
    let title: String
    let content: () -> Content
    let bottomBar: () -> BottomBar

    init(
        title: String,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder bottomBar: @escaping () -> BottomBar
    ) {
        self.title = title
        self.content = content
        self.bottomBar = bottomBar
    }

    var body: some View {
        NavigationStack {

            ZStack(alignment: .bottom) {

                // BACKGROUND
                SolidusBackground()
                    .ignoresSafeArea()

                // MAIN CONTENT
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {

                        // MATCH SHEET SPACING
                        Spacer().frame(height: SolidusHeaderLayout.headerTopPadding - 60)

                        // PAGE CONTENT
                        content()
                            .padding(.horizontal, 24)

                        // EXTRA SPACE TO FLOAT ABOVE BAR
                        Spacer().frame(height: SolidusBottomLayout.bottomPadding)
                    }
                }
                .scrollContentBackground(.hidden)

                // FIXED BOTTOM SEARCH BAR
                VStack(spacing: 0) {
                    bottomBar()
                        .padding(.horizontal, SolidusBottomLayout.bottomOffset)
                        .padding(.bottom, SolidusBottomLayout.bottomPadding - 48)
                }
                .ignoresSafeArea(edges: .bottom)
            }

            // APPLE’S BUILT-IN TOOLBAR
            .toolbar {

                // SYSTEM X BUTTON
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismissSheet()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                }

                // MATCHED TITLE
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(SolidusHeaderLayout.titleFont)
                        .foregroundColor(.primary)
                }
            }
            .toolbarTitleDisplayMode(.inline)
        }
    }

    @Environment(\.dismiss) private var dismissSheet
}
