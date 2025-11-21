//
//  SolidusAppApp.swift
//  SolidusApp
//
//  Created by racecar on 11/18/25.
//

import SwiftUI
import SwiftData

@main
struct SolidusApp: App {
    @State private var modelContainer: ModelContainer
    @State private var transactionsVM: TransactionsViewModel
    @State private var accountsVM: AccountsViewModel

    init() {
        let container = try! ModelContainer(
            for: TransactionModel.self,
                BankAccount.self,
                CardAccount.self,
                BankAccountSnapshot.self,
                StatementModel.self
        )
        _modelContainer = State(initialValue: container)
        _transactionsVM = State(initialValue: TransactionsViewModel(context: container.mainContext))
        _accountsVM = State(initialValue: AccountsViewModel(context: container.mainContext))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(transactionsVM)
                .environmentObject(accountsVM)
                .modelContainer(modelContainer)
        }
    }
}
