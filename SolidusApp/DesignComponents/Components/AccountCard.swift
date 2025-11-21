//
//  AccountCard.swift
//  SolidusApp
//
//  Created by racecar on 11/19/25.
//

import SwiftUI
import SwiftData

struct AccountCard: View {

    enum Kind {
        case bank(BankAccount)
        case card(CardAccount)
    }

    let kind: Kind

    @Environment(\.colorScheme) private var scheme

    // SNAPSHOT HELPERS
    private var latestSnapshot: Any? {
        switch kind {
        case .bank(let account):
            return account.snapshots
                .sorted(by: { $0.statementDate > $1.statementDate })
                .first

        case .card(let account):
            return account.snapshots
                .sorted(by: { $0.statementDate > $1.statementDate })
                .first
        }
    }

    private var latestDate: Date? {
        switch latestSnapshot {
        case let snap as BankAccountSnapshot:
            return snap.statementDate
        case let snap as CardAccountSnapshot:
            return snap.statementDate
        default:
            return nil
        }
    }

    private var latestBalance: Double? {
        switch latestSnapshot {
        case let snap as BankAccountSnapshot:
            return snap.endingBalance
        case let snap as CardAccountSnapshot:
            return snap.endingBalance
        default:
            return nil
        }
    }

    private var title: String {
        switch kind {
        case .bank(let a): return a.displayName
        case .card(let a): return a.displayName
        }
    }

    private var kindFallbackIcon: String {
        switch kind {
        case .bank: return "building.columns"
        case .card: return "creditcard"
        }
    }

    // LOGOS
    private var logoView: some View {

        let name: String = {
            switch kind {
            case .bank(let a): return a.bankName
            case .card(let a): return a.cardName
            }
        }()

        let assetName = name
            .lowercased()
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: "-", with: "")
            + "_logo"

        return Group {
            if UIImage(named: assetName) != nil {
                Image(assetName)
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
            } else {
                Image(systemName: kindFallbackIcon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(Color("background_teal"))
                    .frame(width: 44, height: 44)
            }
        }
        .clipped()
    }

    // CARD
    var body: some View {
        HStack(spacing: 14) {

            // Logo
            logoView

            // Title + Date
            VStack(alignment: .leading, spacing: 4) {

                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.primary)

                if let date = latestDate {
                    Text("As of \(date.formatted(date: .abbreviated, time: .omitted))")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                } else {
                    Text("No statements yet")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            // Balance (bank or card)
            if let bal = latestBalance {
                Text(bal, format: .currency(code: "USD"))
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color("accent_mint"))
                    .minimumScaleFactor(0.7)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(cardBackground)
        .solidusRounded(
            radius: 18,
            shadowOpacity: 0.10,
            shadowRadius: 8,
            shadowY: 3
        )
        .animation(SolidusAnimation.smooth, value: latestBalance)
    }

    // BACKGROUND
    private var cardBackground: some View {
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
    }
}
