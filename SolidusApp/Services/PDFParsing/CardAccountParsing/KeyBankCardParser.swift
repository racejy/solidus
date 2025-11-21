//
//  KeyBankCardParser.swift
//  SolidusApp
//
//  Created by racecar on 11/20/25.
//

import Foundation

final class KeyBankCardParser: CardStatementParser {

    // PARSING LOGIC
    func parseCardStatement(from pdfURL: URL) throws -> CardAccountSnapshot {

        let text = try PDFTextExtractor.extractText(from: pdfURL)

        let accountSuffix = try Self.extractAccountNumberSuffix(from: text)
        let statementDate = try Self.extractStatementEndDate(from: text)

        let previousBalance = Self.extractMoney(regex: #"\*Previous Balance\s*\$([0-9,]+\.\d{2})"#, in: text)
        let paymentsAndCredits = Self.extractSignedMoney(regex: #"Payments and Other Credits\s*([\-+]?)\s*\$([0-9,]+\.\d{2})"#, in: text)
        let totalPurchases = Self.extractSignedMoney(regex: #"Purchases and Adjustments\s*([\-+]?)\s*\$([0-9,]+\.\d{2})"#, in: text)
        let totalFees = Self.extractSignedMoney(regex: #"Fees Charged\s*([\-+]?)\s*\$([0-9,]+\.\d{2})"#, in: text)
        let totalInterest = Self.extractSignedMoney(regex: #"Interest Charged\s*([\-+]?)\s*\$([0-9,]+\.\d{2})"#, in: text)

        guard let endingBalance = Self.extractMoney(regex: #"\*New Balance\s*\$([0-9,]+\.\d{2})"#, in: text) else {
            throw ParserError.missingField("New Balance")
        }

        let creditLimit = Self.extractMoney(regex: #"Credit Limit\s*\$([0-9,]+\.\d{2})"#, in: text)
        let availableCredit = Self.extractMoney(regex: #"Total Available Credit\s*\$([0-9,]+\.\d{2})"#, in: text)

        return CardAccountSnapshot(
            statementDate: statementDate,
            endingBalance: endingBalance,
            accountNumberSuffix: accountSuffix,
            previousBalance: previousBalance,
            paymentsAndCredits: paymentsAndCredits,
            totalPurchases: totalPurchases,
            totalFees: totalFees,
            totalInterest: totalInterest,
            creditLimit: creditLimit,
            availableCredit: availableCredit,
            pdfFilePath: pdfURL.path
        )
    }

    // NUMBER HELPERS
    private static func extractMoney(regex: String, in text: String) -> Double? {
        guard let match = text.range(of: regex, options: .regularExpression) else { return nil }
        let substring = text[match]

        if let numRange = substring.range(of: #"\$([0-9,]+\.\d{2})"#,
                                          options: .regularExpression) {
            let numberString = substring[numRange]
                .replacingOccurrences(of: "$", with: "")
                .replacingOccurrences(of: ",", with: "")
            return Double(numberString)
        }
        return nil
    }

    private static func extractSignedMoney(regex: String, in text: String) -> Double? {
        guard let match = text.range(of: regex, options: .regularExpression) else { return nil }

        let matchStr = String(text[match])

        let sign = matchStr.contains("-") ? -1.0 : 1.0

        if let numRange = matchStr.range(of: #"\$([0-9,]+\.\d{2})"#,
                                         options: .regularExpression) {
            let numberString = matchStr[numRange]
                .replacingOccurrences(of: "$", with: "")
                .replacingOccurrences(of: ",", with: "")

            return (Double(numberString) ?? 0) * sign
        }
        return nil
    }

    // STATEMENT DATE
    private static func extractStatementEndDate(from text: String) throws -> Date {
        let pattern = #"to\s+([A-Za-z]+\s+\d{1,2},\s+\d{4})"#

        guard let match = text.range(of: pattern, options: .regularExpression) else {
            throw ParserError.missingField("Statement Date")
        }

        let dateString = String(text[match])
            .replacingOccurrences(of: "to ", with: "")

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = formatter.date(from: dateString) else {
            throw ParserError.missingField("Statement Date Format")
        }

        return date
    }

    // LAST 4 DIGITS
    private static func extractAccountNumberSuffix(from text: String) throws -> String {
        let pattern = #"XXXX\s+XXXX\s+XXXX\s+(\d{4})"#

        guard let match = text.range(of: pattern,
                                     options: .regularExpression) else {
            throw ParserError.missingField("Account Number Suffix")
        }

        return String(text[match])
            .replacingOccurrences(of: "XXXX XXXX XXXX ", with: "")
    }

    // ERROR
    enum ParserError: Error {
        case missingField(String)
    }
}
