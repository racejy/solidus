//
//  DashboardView.swift
//  Solidus
//
//  Created by racecar on 11/18/25.
//

import SwiftUI
import SwiftData

struct DashboardView: View {

    @Query(sort: \BankAccount.bankName) private var bankAccounts: [BankAccount]
    @Query(sort: \CardAccount.cardName) private var cardAccounts: [CardAccount]

    var body: some View {

        SolidusFullPage(title: "Dashboard") {

            // BANK ACCOUNTS
            if !bankAccounts.isEmpty {
                VStack(alignment: .leading, spacing: 10) {

                    // Bank accounts section label
                    SolidusSectionLabel(text: "BANK ACCOUNTS")

                    VStack(spacing: 14) {
                        ForEach(bankAccounts) { acct in
                            AccountCard(kind: .bank(acct))
                        }
                    }
                }
            }

            // CARD ACCOUNTS
            if !cardAccounts.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    
                    // Card accounts section label
                    SolidusSectionLabel(text: "CARD ACCOUNTS")

                    VStack(spacing: 14) {
                        ForEach(cardAccounts) { acct in
                            AccountCard(kind: .card(acct))
                        }
                    }
                }
            }
        }
    }
}
