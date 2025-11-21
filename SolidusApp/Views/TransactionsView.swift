//
//  TransactionsView.swift
//  Solidus
//
//  Created by racecar on 11/18/25.
//

import SwiftUI
import Foundation

struct TransactionsView: View {
    @Environment(\.colorScheme) private var scheme
    @EnvironmentObject var txVM: TransactionsViewModel

    @State private var searchText = ""
    @State private var showFilterSheet = false

    var body: some View {

        SolidusFullPage(title: "Transactions") {

            // SEARCH BAR
            VStack(alignment: .leading, spacing: 10) {
                searchBar
            }

            // TRANSACTION SECTIONS
            VStack(alignment: .leading, spacing: 26) {
                ForEach(groupedTransactions, id: \.0) { (day, items) in

                    VStack(alignment: .leading, spacing: 10) {

                        SolidusSectionLabel(text: day)

                        VStack(spacing: 14) {
                            ForEach(items) { trx in
                                row(trx)
                                    .swipeActions {
                                        Button(role: .destructive) {
                                            txVM.delete(trx)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showFilterSheet) {
            filterSheet
        }
    }
}

// SEARCH BAR
private extension TransactionsView {
    var searchBar: some View {
        HStack(spacing: 10) {

            // INPUT FIELD
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray.opacity(0.7))
                    .font(.system(size: 18))

                TextField("Search transactions…", text: $searchText)
                    .foregroundColor(.primary)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .background(
                ZStack {
                    SolidusGlass(
                        color: scheme == .light ? .white : .black.opacity(0.9),
                        opacity: scheme == .light ? 0.16 : 0.22
                    )

                    RoundedRectangle(cornerRadius: 18)
                        .fill(
                            scheme == .light
                            ? Color.white.opacity(0.22)
                            : Color.white.opacity(0.06)
                        )
                }
                .clipShape(RoundedRectangle(cornerRadius: 18))
            )
            .shadow(color: .black.opacity(0.08), radius: 8, y: 3)

            // FILTER BUTTON
            Button { showFilterSheet = true } label: {
                Image(systemName: "line.horizontal.3.decrease.circle")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(Color("background_teal"))
                    .frame(width: 44, height: 44)
                    .background(
                        ZStack {
                            SolidusGlass(
                                color: scheme == .light ? .white : .black.opacity(0.9),
                                opacity: scheme == .light ? 0.16 : 0.22
                            )

                            RoundedRectangle(cornerRadius: 14)
                                .fill(
                                    scheme == .light
                                    ? Color.white.opacity(0.22)
                                    : Color.white.opacity(0.06)
                                )
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    )
            }
            .buttonStyle(.plain)
        }
    }
}

// GROUP LOGIC
private extension TransactionsView {
    var filteredTransactions: [TransactionModel] {
        guard !searchText.isEmpty else { return txVM.transactions }

        return txVM.transactions.filter { trx in
            trx.title.lowercased().contains(searchText.lowercased()) ||
            (trx.category ?? "").lowercased().contains(searchText.lowercased())
        }
    }

    var groupedTransactions: [(String, [TransactionModel])] {
        filteredTransactions.groupedByDay()
    }
}

// DAY GROUP
private extension TransactionsView {
    func section(day: String, items: [TransactionModel]) -> some View {
        VStack(alignment: .leading, spacing: 10) {

            SolidusSectionLabel(text: day)

            VStack(spacing: 14) {
                ForEach(items) { trx in
                    row(trx)
                }
            }
        }
    }
}

// TRANSACTION ROW
private extension TransactionsView {
    func row(_ trx: TransactionModel) -> some View {
        HStack(spacing: 14) {

            // ICON
            ZStack {
                Circle()
                    .fill(Color("background_teal").opacity(0.12))

                Image(systemName: "tag")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color("background_teal"))
            }
            .frame(width: 38, height: 38)

            // NAME + CATEGORY
            VStack(alignment: .leading, spacing: 3) {
                Text(trx.title)
                    .font(.system(size: 17, weight: .semibold))

                Text(trx.category ?? "Uncategorized")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }

            Spacer()

            // AMOUNT
            Text(formatted(trx.amount))
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(
                    trx.amount >= 0 ?
                    Color("accent_mint") :
                    Color.primary.opacity(0.88)
                )
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            ZStack {
                SolidusGlass(
                    color: scheme == .light ? .white : .black.opacity(0.85),
                    opacity: scheme == .light ? 0.14 : 0.22
                )

                RoundedRectangle(cornerRadius: 18)
                    .fill(
                        scheme == .light
                        ? Color.white.opacity(0.22)
                        : Color.white.opacity(0.06)
                    )
            }
        )
        .solidusRounded(
            radius: 18,
            shadowOpacity: 0.10,
            shadowRadius: 8,
            shadowY: 3
        )
    }
}

// FILTER SHEET
private extension TransactionsView {
    var filterSheet: some View {
        VStack(spacing: 18) {
            Text("Filters Coming Soon")
                .font(.system(size: 20, weight: .semibold))

            Text("Filter by category, account, date range, or amount.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .presentationDetents([.medium])
    }
}

// FORMATTER
private extension TransactionsView {
    func formatted(_ amount: Double) -> String {
        let sign = amount >= 0 ? "+" : "-"
        let v = abs(amount).formatted(.number.precision(.fractionLength(2)))
        return "\(sign)$\(v)"
    }
}
