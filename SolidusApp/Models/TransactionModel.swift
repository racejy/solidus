//
//  TransactionModel.swift
//  SolidusApp
//
//  Created by racecar on 11/18/25.
//

import Foundation
import SwiftData

enum AccountType: String, Codable {
    case bank
    case card
}

@Model
final class TransactionModel {
    @Attribute(.unique) var id: UUID
    var title: String
    var category: String?
    var amount: Double
    var date: Date

    // Optional linkage to BankAccount or CardAccount
    var accountID: UUID?
    var accountType: AccountType?

    init(
        id: UUID = UUID(),
        title: String,
        category: String? = nil,
        amount: Double,
        date: Date,
        accountID: UUID? = nil,
        accountType: AccountType? = nil
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.amount = amount
        self.date = date
        self.accountID = accountID
        self.accountType = accountType
    }
}
