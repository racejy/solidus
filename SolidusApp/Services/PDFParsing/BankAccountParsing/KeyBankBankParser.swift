//
//  KeyBankBankParser.swift
//  SolidusApp
//
//  Created by racecar on 11/20/25.
//

import Foundation

final class KeyBankBankParser: BankStatementParser {

    // PARSING LOGIC
    func parseBankStatement(from pdfURL: URL) throws -> BankAccountSnapshot {

        // PDF EXTRACTOR
        let text = try PDFTextExtractor.extractText(from: pdfURL)

        let accountSuffix = try Self.extractAccountNumberSuffix(from: text)
        let accountType = Self.extractAccountType(from: text)
        let statementDate = try Self.extractStatementEndDate(from: text)

        let beginningBalance = Self.extractMoney(regex: #"Beginning Balance.*?\$([0-9,]+\.\d{2})"#, in: text)
        let totalDeposits = Self.extractMoney(regex: #"Deposits[^\n]*?\$([0-9,]+\.\d{2})"#, in: text)
        let totalInterest = Self.extractMoney(regex: #"Interest[^\n]*?\$([0-9,]+\.\d{2})"#, in: text)
        let totalWithdrawals = Self.extractMoney(regex: #"Withdrawals[^\n]*?-\$([0-9,]+\.\d{2})"#, in: text)
        let totalFees = Self.extractMoney(regex: #"Total All Fees.*?-\$([0-9,]+\.\d{2})"#, in: text)

        guard let endingBalance = Self.extractMoney(
            regex: #"Ending Balance.*?\$([0-9,]+\.\d{2})"#,
            in: text
        ) else {
            throw ParserError.missingField("Ending Balance")
        }

        return BankAccountSnapshot(
            statementDate: statementDate,
            endingBalance: endingBalance,
            accountNumberSuffix: accountSuffix,
            beginningBalance: beginningBalance,
            totalDeposits: totalDeposits,
            totalInterest: totalInterest,
            totalWithdrawals: totalWithdrawals,
            totalFees: totalFees,
            accountType: accountType,
            pdfFilePath: pdfURL.path
        )
    }

    // PARSING HELPERS
    private static func extractMoney(regex: String, in text: String) -> Double? {
        guard let match = text.range(of: regex, options: .regularExpression) else {
            return nil
        }

        let substring = text[match]
        if let dollarMatch = substring.range(
            of: #"\$([0-9,]+\.\d{2})"#,
            options: .regularExpression
        ) {
            let numberString = substring[dollarMatch]
                .replacingOccurrences(of: "$", with: "")
                .replacingOccurrences(of: ",", with: "")

            return Double(numberString)
        }

        return nil
    }

    // STATEMENT DATES
    private static func extractStatementEndDate(from text: String) throws -> Date {
        let pattern = #"to\s+([A-Za-z]+\s+\d{1,2},\s+\d{4})"#

        guard let match = text.range(of: pattern, options: .regularExpression) else {
            throw ParserError.missingField("Statement End Date")
        }

        let dateString = String(text[match]).replacingOccurrences(of: "to ", with: "")

        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = formatter.date(from: dateString) else {
            throw ParserError.missingField("Statement End Date (format)")
        }

        return date
    }

    // LAST 4 DIGITS
    private static func extractAccountNumberSuffix(from text: String) throws -> String {
        let pattern = #"Account number ending:\s*(\d{3,4})"#

        guard let match = text.range(of: pattern, options: .regularExpression) else {
            throw ParserError.missingField("Account Number Suffix")
        }

        let result = text[match]

        if let numRange = result.range(of: #"\d{3,4}"#, options: .regularExpression) {
            return String(result[numRange])
        }

        throw ParserError.missingField("Account Number Suffix")
    }

    // ACCOUNT TYPE
    private static func extractAccountType(from text: String) -> String {
        if text.contains("Key Select Checking") { return "Checking" }
        if text.contains("Key Select Money Market Savings") { return "Savings" }
        return "Bank Account"
    }

    // ERRORS
    enum ParserError: Error {
        case invalidPDF
        case missingField(String)
    }
}
