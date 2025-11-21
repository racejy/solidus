//
//  FABMenu.swift
//  Solidus
//
//  Created by racecar on 11/18/25.
//

import SwiftUI

struct FABMenu: View {
    @Binding var isOpen: Bool
    
    var addTransaction: () -> Void
    var addAccount: () -> Void
    var importPDF: () -> Void
    
    private let itemSpacing = SolidusFABLayout.fabMenuItemSpacing
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            // BACKDROP
            if isOpen {
                ZStack {
                    SolidusBackdropBlur(style: .systemUltraThinMaterialDark)
                        .ignoresSafeArea()

                    Color.black.opacity(0.25)
                        .ignoresSafeArea()
                }
                .transition(.opacity)
                .onTapGesture {
                    withAnimation(SolidusAnimation.smooth) {
                        isOpen = false
                    }
                }
            }
            
            // MENU ITEMS
            if isOpen {
                VStack(alignment: .trailing, spacing: itemSpacing) {

                    FABMenuItem(
                        icon: "arrow.up.arrow.down",
                        label: "Add Transaction",
                        action: {
                            isOpen = false
                            addTransaction()
                        }
                    )

                    FABMenuItem(
                        icon: "creditcard",
                        label: "Add Account",
                        action: {
                            isOpen = false
                            addAccount()
                        }
                    )

                    FABMenuItem(
                        icon: "doc.text",
                        label: "Import Statement",
                        action: {
                            isOpen = false
                            importPDF()
                        }
                    )

                    // WHITE X
                    Button {
                        withAnimation(SolidusAnimation.smooth) {
                            isOpen = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .solidusIconButton(size: 24, color: .white)
                            .shadow(color: .black.opacity(0.25), radius: 10, y: 4)
                    }
                    .padding(.trailing, 6)
                }
                .padding(.bottom, SolidusFABLayout.fabMenuVerticalOffset - 65)
                .padding(.trailing, SolidusFABLayout.fabTrailingPadding)
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(SolidusAnimation.smooth, value: isOpen)
    }
}
