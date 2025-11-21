//
//  AccountsViewModel.swift
//  SolidusApp
//
//  Created by racecar on 11/18/25.
//

import SwiftUI
import Foundation
import SwiftData
import Combine

@MainActor
class AccountsViewModel: ObservableObject {

    @Published var bankAccounts: [BankAccount] = []
    @Published var cardAccounts: [CardAccount] = []

    let context: ModelContext

    init(context: ModelContext) {
        self.context = context
        loadAccounts()
    }

    // TYPE
    enum AccountType: String, CaseIterable {
        case bank = "Bank"
        case card = "Card"
    }

    // MARK: - LOAD ACCOUNTS FROM SWIFTDATA
    func loadAccounts() {
        do {
            bankAccounts = try context.fetch(FetchDescriptor<BankAccount>())
            cardAccounts = try context.fetch(FetchDescriptor<CardAccount>())
        } catch {
            print("Failed to load accounts: \(error)")
            bankAccounts = []
            cardAccounts = []
        }
    }

    // ADD
    func addAccount(type: AccountType, name: String, last4: String, nickname: String?) {
        switch type {
        case .bank:
            addBankAccount(name: name, last4: last4, nickname: nickname)
        case .card:
            addCardAccount(name: name, last4: last4, nickname: nickname)
        }
    }

    func addBankAccount(name: String, last4: String, nickname: String?) {
        let new = BankAccount(bankName: name, last4: last4, nickname: nickname)
        context.insert(new)
        try? context.save()
        loadAccounts()
    }

    func addCardAccount(name: String, last4: String, nickname: String?) {
        let new = CardAccount(cardName: name, last4: last4, nickname: nickname)
        context.insert(new)
        try? context.save()
        loadAccounts()
    }
}
