//
//  CardAccountSnapshotModel.swift
//  SolidusApp
//
//  Created by racecar on 11/18/25.
//

import Foundation
import SwiftData

@Model
final class CardAccountSnapshot {

    // REQUIRED
    var statementDate: Date
    var endingBalance: Double
    var accountNumberSuffix: String

    // SNAPSHOT
    var previousBalance: Double?
    var paymentsAndCredits: Double?
    var totalPurchases: Double?
    var totalFees: Double?
    var totalInterest: Double?

    // OPTIONAL
    var creditLimit: Double?
    var availableCredit: Double?
    var pdfFilePath: String?

    init(
        statementDate: Date,
        endingBalance: Double,
        accountNumberSuffix: String,
        previousBalance: Double? = nil,
        paymentsAndCredits: Double? = nil,
        totalPurchases: Double? = nil,
        totalFees: Double? = nil,
        totalInterest: Double? = nil,
        creditLimit: Double? = nil,
        availableCredit: Double? = nil,
        pdfFilePath: String? = nil
    ) {
        self.statementDate = statementDate
        self.endingBalance = endingBalance
        self.accountNumberSuffix = accountNumberSuffix
        self.previousBalance = previousBalance
        self.paymentsAndCredits = paymentsAndCredits
        self.totalPurchases = totalPurchases
        self.totalFees = totalFees
        self.totalInterest = totalInterest
        self.creditLimit = creditLimit
        self.availableCredit = availableCredit
        self.pdfFilePath = pdfFilePath
    }
}
