//
//  AddTransactionView.swift
//  SolidusApp
//
//  Created by racecar on 11/18/25.
//

import SwiftUI
import SwiftData

struct AddTransactionView: View {

    // ENV
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var txVM: TransactionsViewModel
    @EnvironmentObject var accountsVM: AccountsViewModel
    @Environment(\.colorScheme) private var scheme

    // Transaction Fields
    @State private var title: String = ""
    @State private var category: String = ""
    @State private var amount: String = ""
    @State private var date: Date = Date()

    // Pickers
    @State private var showCategoryPicker = false
    @State private var showAccountPicker = false

    // Account Selection
    @State private var selectedAccountName: String = "None"
    @State private var selectedAccountID: UUID? = nil
    @State private var selectedAccountType: AccountType? = nil

    var body: some View {
        SolidusSheetPage(
            title: "Add Transaction"
        ) {

            VStack(alignment: .leading, spacing: 24) {

                // TITLE FIELD
                SolidusInputField(label: "Title", icon: "note.text") {
                    TextField("Enter title…", text: $title)
                        .foregroundColor(.primary)
                        .textInputAutocapitalization(.words)
                }

                // CATEGORY FIELD
                SolidusInputField(label: "Category", icon: "tag") {
                    HStack {
                        Text(category.isEmpty ? "Select category…" : category)
                            .foregroundColor(category.isEmpty ? .secondary : .primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray.opacity(0.6))
                    }
                    .contentShape(Rectangle())
                    .onTapGesture { showCategoryPicker = true }
                }
                .sheet(isPresented: $showCategoryPicker) {
                    CategoryPickerView(selected: $category)
                }

                // ACCOUNT FIELD
                SolidusInputField(label: "Account", icon: "creditcard") {
                    HStack {
                        Text(selectedAccountName)
                            .foregroundColor(selectedAccountID == nil ? .secondary : .primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray.opacity(0.6))
                    }
                    .contentShape(Rectangle())
                    .onTapGesture { showAccountPicker = true }
                }
                .sheet(isPresented: $showAccountPicker) {
                    AccountPickerView(
                        selectedAccountName: $selectedAccountName,
                        selectedAccountID: $selectedAccountID,
                        selectedAccountType: $selectedAccountType
                    )
                    .environmentObject(accountsVM)
                }

                // AMOUNT FIELD
                SolidusInputField(label: "Amount", icon: "dollarsign") {
                    TextField("Enter amount… - expense // + income", text: $amount)
                        .keyboardType(.numbersAndPunctuation)
                        .foregroundColor(.primary)
                }

                // DATE FIELD
                SolidusInputField(label: "Date", icon: "calendar") {
                    DatePicker("", selection: $date, displayedComponents: .date)
                        .labelsHidden()
                        Spacer()
                }
            }

        } bottomButton: {
            SolidusPrimaryButton(title: "Add Transaction", action: addTransaction)
        }
    }

    // TRANSACTION LOGIC
    private func addTransaction() {
        guard let value = Double(amount) else { return }

        let trx = TransactionModel(
            title: title,
            category: category,
            amount: value,
            date: date,
            accountID: selectedAccountID,
            accountType: selectedAccountType
        )

        txVM.add(trx)
        dismiss()
    }
}
