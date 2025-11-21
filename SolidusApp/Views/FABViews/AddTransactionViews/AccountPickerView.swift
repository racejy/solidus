//
//  AccountPickerView.swift
//  SolidusApp
//
//  Created by racecar on 11/19/25.
//

import SwiftUI

struct AccountPickerView: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var accountsVM: AccountsViewModel
    @Environment(\.colorScheme) private var scheme

    @Binding var selectedAccountName: String
    @Binding var selectedAccountID: UUID?
    @Binding var selectedAccountType: AccountType?

    @State private var searchText = ""

    // FILTER HELPERS
    private func matchesSearch(_ text: String) -> Bool {
        searchText.isEmpty || text.lowercased().contains(searchText.lowercased())
    }

    private func displayNameForBank(_ acct: BankAccount) -> String {
        if let nick = acct.nickname, !nick.isEmpty {
            return "\(nick) ••••\(acct.last4)"
        }
        return "\(acct.bankName) ••••\(acct.last4)"
    }

    private func displayNameForCard(_ card: CardAccount) -> String {
        if let nick = card.nickname, !nick.isEmpty {
            return "\(nick) ••••\(card.last4)"
        }
        return "\(card.cardName) ••••\(card.last4)"
    }

    var body: some View {

        SolidusSearchSheetPage(
            title: "Select Account",
            content: {

                // NO ACCOUNT
                VStack(alignment: .leading, spacing: 12) {
                    SolidusSectionLabel(text: "NO ACCOUNT")

                    accountRow(
                        title: "None",
                        icon: "xmark.circle",
                        isSelected: selectedAccountID == nil
                    ) {
                        withAnimation(SolidusAnimation.smooth) {
                            selectedAccountName = "None"
                            selectedAccountID = nil
                            selectedAccountType = nil
                            dismiss()
                        }
                    }
                }

                // BANK ACCOUNTS
                if !accountsVM.bankAccounts.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {

                        SolidusSectionLabel(text: "BANK ACCOUNTS")

                        ForEach(accountsVM.bankAccounts.filter {
                            matchesSearch(displayNameForBank($0))
                        }) { acct in

                            let label = displayNameForBank(acct)

                            accountRow(
                                title: label,
                                icon: "building.columns.fill",
                                isSelected: selectedAccountID == acct.id
                            ) {
                                withAnimation(SolidusAnimation.smooth) {
                                    selectedAccountName = label
                                    selectedAccountID = acct.id
                                    selectedAccountType = .bank
                                    dismiss()
                                }
                            }
                        }
                    }
                }

                // CARD ACCOUNTS
                if !accountsVM.cardAccounts.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {

                        SolidusSectionLabel(text: "CREDIT CARDS")

                        ForEach(accountsVM.cardAccounts.filter {
                            matchesSearch(displayNameForCard($0))
                        }) { card in

                            let label = displayNameForCard(card)

                            accountRow(
                                title: label,
                                icon: "creditcard.fill",
                                isSelected: selectedAccountID == card.id
                            ) {
                                withAnimation(SolidusAnimation.smooth) {
                                    selectedAccountName = label
                                    selectedAccountID = card.id
                                    selectedAccountType = .card
                                    dismiss()
                                }
                            }
                        }
                    }
                }

            },
            bottomBar: {
                SolidusSearchBar(
                    text: $searchText,
                    placeholder: "Search accounts…"
                )
            }
        )
    }

    // ACCOUNT ROW
    @ViewBuilder
    private func accountRow(
        title: String,
        icon: String,
        isSelected: Bool,
        onTap: @escaping () -> Void
    ) -> some View {

        HStack(spacing: 16) {

            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color("background_teal"))
                .frame(width: 32, height: 32)

            Text(title)
                .font(.system(size: 17))
                .foregroundColor(.primary)

            Spacer()

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(Color("background_teal"))
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 16)
        .background(
            SolidusGlass(
                color: scheme == .light ? .white : .black.opacity(0.9),
                opacity: scheme == .light ? 0.16 : 0.22
            )
        )
        .solidusRounded(
            radius: 18,
            shadowOpacity: 0.10,
            shadowRadius: 8,
            shadowY: 3
        )
        .contentShape(Rectangle())
        .onTapGesture { onTap() }
    }
}
