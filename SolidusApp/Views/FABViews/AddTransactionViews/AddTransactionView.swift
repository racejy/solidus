//
//  AddTransactionView.swift
//  SolidusApp
//
//  Created by racecar on 11/18/25.
//

import SwiftUI
import SwiftData

struct AddTransactionView: View {
    
    // ENVIRONMENT
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var txVM: TransactionsViewModel
    @EnvironmentObject var accountsVM: AccountsViewModel
    @Environment(\.colorScheme) private var scheme
    
    // STATE
    @State private var title: String = ""
    @State private var category: String = ""
    @State private var amount: String = ""
    @State private var date: Date = .now
    
    @State private var selectedAccountID: UUID? = nil
    @State private var selectedAccountType: AccountType? = nil
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // BACKGROUND
            Color.clear
                .solidusBackground()
                .overlay(
                    Color.white.opacity(scheme == .light ? 0.06 : 0.03)
                )
                .ignoresSafeArea()
            
            // CONTENT
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    
                    Spacer().frame(height: 12)
                    
                    inputSection
                    accountPicker
                    datePicker
                    
                    Spacer(minLength: 160)
                }
                .padding(.horizontal, 24)
            }
            
            // BOTTOM BUTTON
            bottomButton
        }
        .solidusSheetToolbar(title: "Add Transaction", onDismiss: { dismiss() })
    }
}

//
// MARK: - INPUT FIELDS
//

private extension AddTransactionView {
    
    var inputSection: some View {
        VStack(spacing: 24) {
            
            SolidusInputField(label: "Title", icon: "note.text") {
                TextField("Transaction title…", text: $title)
                    .textInputAutocapitalization(.words)
            }
            
            SolidusInputField(label: "Category", icon: "tag") {
                TextField("Groceries, Rent, etc…", text: $category)
            }
            
            SolidusInputField(label: "Amount", icon: "dollarsign") {
                TextField("0.00", text: $amount)
                    .keyboardType(.decimalPad)
            }
        }
    }
}

//
// MARK: - ACCOUNT PICKER
//

private extension AddTransactionView {
    
    var accountPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Account")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
                .padding(.leading, 4)
            
            Menu {
                
                // BANK ACCOUNTS
                if !accountsVM.bankAccounts.isEmpty {
                    Section("Bank Accounts") {
                        ForEach(accountsVM.bankAccounts) { acc in
                            Button {
                                selectedAccountID = acc.id
                                selectedAccountType = .bank
                            } label: {
                                Text("\(acc.bankName) ••••\(acc.last4)")
                            }
                        }
                    }
                }
                
                // CARD ACCOUNTS
                if !accountsVM.cardAccounts.isEmpty {
                    Section("Cards") {
                        ForEach(accountsVM.cardAccounts) { acc in
                            Button {
                                selectedAccountID = acc.id
                                selectedAccountType = .card
                            } label: {
                                Text("\(acc.cardName) ••••\(acc.last4)")
                            }
                        }
                    }
                }
                
            } label: {
                HStack {
                    Text(selectedAccountLabel)
                        .foregroundColor(selectedAccountID == nil ? .secondary : .primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                .background(
                    SolidusGlass(
                        color: scheme == .light ? .white : .black.opacity(0.8),
                        opacity: scheme == .light ? 0.16 : 0.22
                    )
                )
                .solidusRounded(radius: 20)
            }
        }
    }
    
    var selectedAccountLabel: String {
        guard let id = selectedAccountID else { return "Select account…" }
        
        if selectedAccountType == .bank,
           let acc = accountsVM.bankAccounts.first(where: { $0.id == id }) {
            return "\(acc.bankName) ••••\(acc.last4)"
        }
        if selectedAccountType == .card,
           let acc = accountsVM.cardAccounts.first(where: { $0.id == id }) {
            return "\(acc.cardName) ••••\(acc.last4)"
        }
        
        return "Select account…"
    }
}

//
// MARK: - DATE PICKER
//

private extension AddTransactionView {
    
    var datePicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Date")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
                .padding(.leading, 4)
            
            DatePicker("", selection: $date, displayedComponents: .date)
                .datePickerStyle(.compact)
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                .background(
                    SolidusGlass(
                        color: scheme == .light ? .white : .black.opacity(0.8),
                        opacity: scheme == .light ? 0.16 : 0.22
                    )
                )
                .solidusRounded(radius: 20)
        }
    }
}

//
// MARK: - BOTTOM BUTTON
//

private extension AddTransactionView {
    
    var bottomButton: some View {
        VStack {
            Spacer()
            
            Button(action: saveTransaction) {
                HStack {
                    Spacer()
                    Text("Add Transaction")
                        .font(.system(size: 18, weight: .bold))
                        .padding(.vertical, 18)
                    Spacer()
                }
                .background(Color("background_teal"))
                .foregroundColor(.white)
                .cornerRadius(24)
                .shadow(color: Color("background_teal").opacity(0.35), radius: 10, y: 5)
                .padding(.horizontal, SolidusFABLayout.fabTrailingPadding)
                .padding(.bottom, SolidusFABLayout.fabBottomPadding + 36)
            }
        }
        .ignoresSafeArea()
    }
}

//
// MARK: - SAVE LOGIC
//

private extension AddTransactionView {
    
    func saveTransaction() {
        guard let amountValue = Double(amount) else { return }
        
        txVM.addTransaction(
            title: title,
            category: category.isEmpty ? nil : category,
            amount: amountValue,
            date: date,
            accountID: selectedAccountID,
            accountType: selectedAccountType
        )
        
        dismiss()
    }
}
