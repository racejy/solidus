//
//  CardAccountSnapshot.swift
//  SolidusApp
//
//  Created by racecar on 11/18/25.
//

import Foundation
import SwiftData

@Model
final class CardAccountSnapshot {
    var statementDate: Date
    var balance: Double

    // FILE PATH
    var pdfFilePath: String?

    init(statementDate: Date, balance: Double, pdfFilePath: String? = nil) {
        self.statementDate = statementDate
        self.balance = balance
        self.pdfFilePath = pdfFilePath
    }
}
