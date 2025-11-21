//
//  ContentView.swift
//  SolidusApp
//
//  Created by racecar on 11/18/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    // ENV
    @Environment(\.colorScheme) var colorScheme
    
    // DATA BASES
    @EnvironmentObject var accountsVM: AccountsViewModel
    @EnvironmentObject var txVM: TransactionsViewModel
    
    @State private var selectedTab: Tab = .dashboard
    
    @State private var showMenu = false
    @State private var showFABMenu = false
    
    @State private var showAddAccount = false
    @State private var showAddTransaction = false
    @State private var showImportPDF = false

    
    var body: some View {
        ZStack(alignment: .bottom) {

            // BACKGROUND FADES
            SolidusBackground()
            
            // MAIN PAGES
            Group {
                switch selectedTab {
                case .dashboard: DashboardView()
                case .transactions: TransactionsView()
                case .budget: BudgetView()
                }
            }

            // BOTTOM NAV + FAB
            HStack {
                FloatingNavBar(selectedTab: $selectedTab)
                Spacer()

                FABMenuButton {
                    showFABMenu.toggle()
                }
                .opacity(showFABMenu ? 0.25 : 1)
            }
            .padding(.horizontal, SolidusFABLayout.fabTrailingPadding)
            .padding(.bottom, SolidusFABLayout.fabBottomPadding)

            // FAB MENU OVERLAY
            FABMenu(
                isOpen: $showFABMenu,
                addTransaction: {
                    showAddTransaction = true
                },
                addAccount: {
                    showAddAccount = true
                },
                importPDF: {
                    showImportPDF = true
                }
            )
        }
        
        // HAMBURGER BUTTON
        .overlay(alignment: .topLeading) {
            HamburgerMenuButton {
                showMenu.toggle()
            }
            .padding(.top, -5)
            .padding(.leading, 16)
        }

        // ADD TRANSACTION
        .sheet(isPresented: $showAddTransaction) {
            AddTransactionView()
                .environmentObject(txVM)
                .environmentObject(accountsVM)
                .presentationDetents([.large])
        }
        
        // ADD ACCOUNT
        .sheet(isPresented: $showAddAccount) {
            AddAccountView()
                .environmentObject(accountsVM)
                .presentationDetents([.large])
        }

        // IMPORT STATEMENT
        .sheet(isPresented: $showImportPDF) {
            ImportStatementView()
                .environmentObject(accountsVM)
                .presentationDetents([.large])
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
