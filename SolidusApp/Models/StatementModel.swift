//
//  StatementModel.swift
//  SolidusApp
//
//  Created by racecar on 11/20/25.
//

import Foundation
import SwiftData

@Model
final class StatementModel {
    @Attribute(.unique) var id: UUID
    
    // FILE INFO
    var filePath: String        // path in Documents/SolidusStatements
    var fileName: String
    
    // BUSINESS INFO
    var statementDate: Date
    var endingBalance: Double
    
    // METADATA
    var importedAt: Date

    // LINK TO ACCOUNT
    var accountID: UUID?
    var accountType: AccountType?

    init(
        id: UUID = UUID(),
        filePath: String,
        fileName: String,
        statementDate: Date,
        endingBalance: Double,
        importedAt: Date = Date(),
        accountID: UUID? = nil,
        accountType: AccountType? = nil
    ) {
        self.id = id
        self.filePath = filePath
        self.fileName = fileName
        self.statementDate = statementDate
        self.endingBalance = endingBalance
        self.importedAt = importedAt
        self.accountID = accountID
        self.accountType = accountType
    }
}
