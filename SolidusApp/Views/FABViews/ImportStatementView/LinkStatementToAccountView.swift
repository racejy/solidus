//
//  LinkStatementToAccountView.swift
//  SolidusApp
//
//  Created by racecar on 11/19/25.
//

import SwiftUI
import SwiftData

struct LinkStatementToAccountView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var scheme
    @EnvironmentObject var accountsVM: AccountsViewModel

    let pdfURL: URL

    // USER SELECTIONS
    @State private var selectedAccountID: UUID? = nil
    @State private var selectedAccountType: AccountType? = nil
    @State private var selectedAccountName: String = "None"

    @State private var showAccountPicker = false

    // PARSING STATE
    @State private var isProcessing = false
    @State private var parseError: String? = nil

    var body: some View {
        SolidusSheetPage(
            title: "Link Statement"
        ) {

            VStack(alignment: .leading, spacing: 24) {

                // PDF PREVIEW
                VStack(alignment: .leading, spacing: 12) {

                    SolidusSectionLabel(text: "PDF FILE")

                    ZStack {
                        SolidusGlass(
                            color: scheme == .light ? .white : .black.opacity(0.8),
                            opacity: scheme == .light ? 0.16 : 0.22
                        )

                        VStack(alignment: .leading, spacing: 8) {

                            Text(pdfURL.lastPathComponent)
                                .font(.system(size: 17, weight: .semibold))

                            Text(pdfURL.path)
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                                .truncationMode(.middle)
                        }
                        .padding(16)
                    }
                    .solidusRounded(
                        radius: 20,
                        shadowOpacity: 0.10,
                        shadowRadius: 8,
                        shadowY: 3
                    )
                }
                .padding(.horizontal, 24)

                // ACCOUNT PICKER
                VStack(alignment: .leading, spacing: 12) {

                    SolidusSectionLabel(text: "LINK TO ACCOUNT")

                    Button {
                        showAccountPicker = true
                    } label: {
                        HStack {
                            Text(selectedAccountName)
                                .font(.system(size: 17))
                                .foregroundColor(.primary)

                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .background(
                            SolidusGlass(
                                color: scheme == .light ? .white : .black.opacity(0.8),
                                opacity: scheme == .light ? 0.16 : 0.22
                            )
                        )
                        .solidusRounded(
                            radius: 20,
                            shadowOpacity: 0.10,
                            shadowRadius: 8,
                            shadowY: 3
                        )
                    }
                }
                .padding(.horizontal, 24)

                // ERROR MESSAGE
                if let err = parseError {
                    Text(err)
                        .foregroundColor(.red)
                        .font(.system(size: 15))
                        .padding(.horizontal, 24)
                }
            }

        } bottomButton: {
            SolidusPrimaryButton(
                title: isProcessing ? "Processing…" : "Categorize PDF",
                action: categorizePDF
            )
            .disabled(selectedAccountID == nil || isProcessing)
            .opacity(selectedAccountID == nil ? 0.55 : 1)
        }
        .sheet(isPresented: $showAccountPicker) {
            AccountPickerView(
                selectedAccountName: $selectedAccountName,
                selectedAccountID: $selectedAccountID,
                selectedAccountType: $selectedAccountType
            )
            .environmentObject(accountsVM)
        }
    }

    // GET HELPERS
    var selectedInstitutionName: String {
        guard let id = selectedAccountID,
              let type = selectedAccountType else { return "Unknown" }

        switch type {
        case .bank:
            return accountsVM.bankAccounts.first(where: { $0.id == id })?.bankName ?? "Unknown"
        case .card:
            return accountsVM.cardAccounts.first(where: { $0.id == id })?.cardName ?? "Unknown"
        }
    }

    var selectedLastFour: String {
        guard let id = selectedAccountID,
              let type = selectedAccountType else { return "0000" }

        switch type {
        case .bank:
            return accountsVM.bankAccounts.first(where: { $0.id == id })?.last4 ?? "0000"
        case .card:
            return accountsVM.cardAccounts.first(where: { $0.id == id })?.last4 ?? "0000"
        }
    }
}

// PARSING LOGIC
private extension LinkStatementToAccountView {

    func categorizePDF() {
        guard let accountID = selectedAccountID,
              let type = selectedAccountType else {
            parseError = "Please select an account first."
            return
        }

        isProcessing = true
        parseError = nil

        Task {
            do {
                let snapshot: Any

                switch type {
                case .bank:
                    let parser = StatementParserFactory.bankParser(for: selectedInstitutionName)
                    snapshot = try parser.parseBankStatement(from: pdfURL)

                case .card:
                    let parser = StatementParserFactory.cardParser(for: selectedInstitutionName)
                    snapshot = try parser.parseCardStatement(from: pdfURL)
                }

                try await saveSnapshot(for: accountID, type: type, snapshot: snapshot)
                try await saveStatementForSnapshot(snapshot, accountID: accountID, type: type)

                isProcessing = false
                dismiss()

            } catch {
                isProcessing = false
                parseError = "Parsing failed: \(error.localizedDescription)"
            }
        }
    }

    func saveSnapshot(for id: UUID, type: AccountType, snapshot: Any) async throws {
        let context = accountsVM.context

        switch type {
        case .bank:
            guard let snap = snapshot as? BankAccountSnapshot,
                  let acct = try? context.fetch(FetchDescriptor<BankAccount>())
                        .first(where: { $0.id == id })
            else { return }

            acct.snapshots.append(snap)

        case .card:
            guard let snap = snapshot as? CardAccountSnapshot,
                  let acct = try? context.fetch(FetchDescriptor<CardAccount>())
                        .first(where: { $0.id == id })
            else { return }

            acct.snapshots.append(snap)
        }

        try context.save()
    }

    func saveStatementForSnapshot(
        _ snapshot: Any,
        accountID: UUID,
        type: AccountType
    ) async throws {

        let context = accountsVM.context

        let statementDate: Date
        let endingBalance: Double

        if let snap = snapshot as? BankAccountSnapshot {
            statementDate = snap.statementDate
            endingBalance = snap.endingBalance
        } else if let snap = snapshot as? CardAccountSnapshot {
            statementDate = snap.statementDate
            endingBalance = snap.endingBalance
        } else {
            throw NSError(domain: "Invalid snapshot type", code: -1)
        }

        let savedPath = try PDFManager.savePDFToDocuments(
            originalURL: pdfURL,
            institutionName: selectedInstitutionName,
            lastFour: selectedLastFour,
            statementDate: statementDate
        )

        let statement = StatementModel(
            filePath: savedPath,
            fileName: URL(fileURLWithPath: savedPath).lastPathComponent,
            statementDate: statementDate,
            endingBalance: endingBalance,
            importedAt: Date(),
            accountID: accountID,
            accountType: type
        )

        context.insert(statement)
        try context.save()
    }
}
