//
//  StatementParserFactory.swift
//  SolidusApp
//
//  Created by racecar on 11/20/25.
//

import Foundation

// IF LOGIC
protocol BankStatementParser {
    func parseBankStatement(from pdfURL: URL) throws -> BankAccountSnapshot
}

protocol CardStatementParser {
    func parseCardStatement(from pdfURL: URL) throws -> CardAccountSnapshot
}

// ELIF LOGIC
enum StatementParserFactory {

    // BANK PARSERS
    static func bankParser(for bankName: String) -> BankStatementParser {
        let lower = bankName.lowercased()

        // KEYBANK BANK
        if lower.contains("keybank") {
            return KeyBankBankParser()
        }
        
//        // UTAH BANK BANK
//        if lower.contains("utah bank") {
//            return UtahBankBankParser()
//        }

//        // WELLS FARGO BANK
//        if lower.contains("wells") {
//            return WellsFargoBankParser()
//        }

//        // US BANK BANK
//        if lower.contains("us bank") {
//            return USBankBankParser()
//        }

//        // CHASE BANK BANK
//        if lower.contains("chase") {
//            return ChaseBankBankParser()
//        }

        fatalError("No bank parser implemented for institution: \(bankName)")
    }


    // CARD PARSERS
    static func cardParser(for cardName: String) -> CardStatementParser {
        let lower = cardName.lowercased()
        
        // KEYBANK CC
        if lower.contains("keybank") {
            return KeyBankCardParser()
        }
        
//        // ROBINHOOD CC
//        if lower.contains("robinhood") {
//            return RobinhoodCardParser()
//        }
        
//        // WELLS FARGO CC
//        if lower.contains("wellsfargo") {
//            return WellsFargoCardParser()
//        }
        
//        // UTAH BANK CC
//        if lower.contains("utah bank") {
//            return UtahBankCardParser()
//        }
        
//        // US BANK CC
//        if lower.contains("us bank") {
//            return USBankCardParser()
//        }

        fatalError("No card parser implemented for card: \(cardName)")
    }
}
