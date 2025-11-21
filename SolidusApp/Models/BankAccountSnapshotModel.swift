//
//  BankAccountSnapshotModel.swift
//  SolidusApp
//
//  Created by racecar on 11/18/25.
//

import Foundation
import SwiftData

@Model
final class BankAccountSnapshot {

    // REQUIRED
    var statementDate: Date
    var endingBalance: Double
    var accountNumberSuffix: String

    // SNAPSHOT
    var beginningBalance: Double?
    var totalDeposits: Double?
    var totalInterest: Double?
    var totalWithdrawals: Double?
    var totalFees: Double?

    // OPTIONAL
    var accountType: String?
    var pdfFilePath: String?

    init(
        statementDate: Date,
        endingBalance: Double,
        accountNumberSuffix: String,
        beginningBalance: Double? = nil,
        totalDeposits: Double? = nil,
        totalInterest: Double? = nil,
        totalWithdrawals: Double? = nil,
        totalFees: Double? = nil,
        accountType: String? = nil,
        pdfFilePath: String? = nil
    ) {
        self.statementDate = statementDate
        self.endingBalance = endingBalance
        self.accountNumberSuffix = accountNumberSuffix
        self.beginningBalance = beginningBalance
        self.totalDeposits = totalDeposits
        self.totalInterest = totalInterest
        self.totalWithdrawals = totalWithdrawals
        self.totalFees = totalFees
        self.accountType = accountType
        self.pdfFilePath = pdfFilePath
    }
}
