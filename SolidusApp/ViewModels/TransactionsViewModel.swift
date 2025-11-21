//
//  TransactionsViewModel.swift
//  SolidusApp
//
//  Created by racecar on 11/18/25.
//

import SwiftUI
import SwiftData
import Foundation
import Combine

@MainActor
class TransactionsViewModel: ObservableObject {
    // DATA
    @Published var transactions: [TransactionModel] = []

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
        loadTransactions()
    }

    // LOAD FROM DATABASE
    func loadTransactions() {
        let descriptor = FetchDescriptor<TransactionModel>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        if let results = try? context.fetch(descriptor) {
            self.transactions = results
        }
    }

    // ADD DATA
    func add(_ trx: TransactionModel) {
        context.insert(trx)
        try? context.save()
        loadTransactions()
    }

    // DELETE DATA
    func delete(_ trx: TransactionModel) {
        context.delete(trx)
        try? context.save()
        loadTransactions()
    }

    // UPDATE DATA
    func update() {
        try? context.save()
        loadTransactions()
    }
}


// HELPERS
extension Array where Element == TransactionModel {

    func groupedByDay() -> [(String, [TransactionModel])] {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"

        let grouped = Dictionary(grouping: self) { trx in
            fmt.string(from: trx.date)
        }

        return grouped
            .sorted { $0.key > $1.key }
            .map { (key, items) in
                (formatDayLabel(from: key), items.sorted { $0.date > $1.date })
            }
    }
}

func formatDayLabel(from raw: String) -> String {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd"
    guard let date = df.date(from: raw) else { return raw }

    if Calendar.current.isDateInToday(date) { return "TODAY" }
    if Calendar.current.isDateInYesterday(date) { return "YESTERDAY" }

    let out = DateFormatter()
    out.dateFormat = "d MMM"
    return out.string(from: date).uppercased()
}
