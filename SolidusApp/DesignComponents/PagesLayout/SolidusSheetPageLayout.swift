//
//  SolidusSheetPageLayout.swift
//  SolidusApp
//
//  Created by racecar on 11/20/25.
//

import SwiftUI
import SwiftData

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
                    VStack(alignment: .leading, spacing: 20) {

                        // Match your header spacing
                        Spacer().frame(height: SolidusHeaderLayout.headerTopPadding + 20)

                        // Page Content
                        content()
                            .padding(.horizontal, 20)

                        // Bottom filler to lift content above button
                        Spacer().frame(height: SolidusBottomLayout.bottomPadding)
                    }
                }

                // FIXED BOTTOM BUTTON
                VStack {
                    Spacer()
                    bottomButton()
                        .padding(.horizontal, SolidusFABLayout.fabTrailingPadding)
                        .padding(.bottom, SolidusFABLayout.fabBottomPadding)
                }
                .ignoresSafeArea()
            }

            // SYSTEM TOOLBAR
            .toolbar {

                // SYSTEM CANCEL / X BUTTON (adaptive)
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
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



#Preview {
    let container = try! ModelContainer(
        for: TransactionModel.self,
            BankAccount.self,
            CardAccount.self,
            BankAccountSnapshot.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    let tvm = TransactionsViewModel(context: container.mainContext)
    let avm = AccountsViewModel(context: container.mainContext)

    ContentView()
        .environmentObject(tvm)
        .environmentObject(avm)
        .modelContainer(container)
}
