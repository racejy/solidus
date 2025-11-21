//
//  AddAccountView.swift
//  SolidusApp
//
//  Created by racecar on 11/18/25.
//

import SwiftUI
import SwiftData

struct AddAccountView: View {

    // ENV
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var scheme
    @EnvironmentObject var accountsVM: AccountsViewModel

    // STATE
    @State private var type: AccountsViewModel.AccountType = .bank
    
    // ACCOUNT DETAILS
    @State private var name: String = ""
    @State private var last4: String = ""
    @State private var nickname: String = ""

    var body: some View {
        SolidusSheetPage(
            title: "Add Account",
            content: {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // SEGMENTED CONTROL
                    accountTypeSegment
                    
                    // INPUT FIELDS
                    VStack(spacing: 24) {
                        
                        SolidusInputField(
                            label: type == .bank ? "Bank Name" : "Card Name",
                            icon: type == .bank ? "building.columns" : "creditcard"
                        ) {
                            TextField(
                                type == .bank ? "Enter bank name…" : "Enter card name…",
                                text: $name
                            )
                            .textInputAutocapitalization(.words)
                        }
                        
                        SolidusInputField(label: "Last 4 Digits", icon: "number") {
                            TextField("1234", text: $last4)
                                .keyboardType(.numberPad)
                        }
                        
                        SolidusInputField(label: "Nickname (optional)", icon: "tag") {
                            TextField("Enter nickname…", text: $nickname)
                        }
                    }
                }
            },
            bottomButton: {
                SolidusPrimaryButton(title: "Add Account") {
                    saveAccount()
                }
            }
        )
        .animation(SolidusAnimation.smooth, value: type)
    }

    // SEGMENTED CONTROL
    private var accountTypeSegment: some View {
        HStack(spacing: 12) {
            ForEach(AccountsViewModel.AccountType.allCases, id: \.self) { option in
                Button {
                    type = option
                } label: {
                    Text(option.rawValue)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(type == option ? .white : .primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    type == option
                                        ? Color("background_teal")
                                        : Color(.secondarySystemBackground)
                                )
                        )
                }
            }
        }
        .padding(.horizontal, 26)
    }

    // SAVE LOGIC
    private func saveAccount() {
        let nick = nickname.isEmpty ? nil : nickname

        accountsVM.addAccount(
            type: type,
            name: name,
            last4: last4,
            nickname: nick
        )

        dismiss()
    }
}
