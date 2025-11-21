//
//  ImportStatementView.swift
//  SolidusApp
//
//  Created by racecar on 11/18/25.
//

import SwiftUI
import UniformTypeIdentifiers
import SwiftData

struct ImportStatementView: View {
    
    // ENV
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var scheme
    @EnvironmentObject var accountsVM: AccountsViewModel
    
    // STATE
    @State private var isShowingFileImporter = false
    @State private var selectedFileName: String? = nil
    @State private var importError: String? = nil
    
    @State private var importedURL: URL? = nil
    @State private var showLinkView = false
    
    var body: some View {
        SolidusSheetPage(
            title: "Import Statement"
        ) {
            VStack(alignment: .leading, spacing: 20) {
                
                // SELECTED FILE SECTION
                VStack(alignment: .leading, spacing: 8) {
                    
                    SolidusSectionLabel(text: "SELECTED FILE")
                    
                    ZStack {
                        SolidusGlass(
                            color: scheme == .light ? .white : .black.opacity(0.8),
                            opacity: scheme == .light ? 0.16 : 0.22
                        )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                            if let file = selectedFileName {
                                Text(file)
                                    .font(.system(size: 17))
                                    .foregroundColor(.primary)
                            } else {
                                Text("No file selected yet.")
                                    .font(.system(size: 17))
                                    .foregroundColor(.secondary)
                            }
                            
                            if let error = importError {
                                Text(error)
                                    .font(.system(size: 14))
                                    .foregroundColor(.red)
                            }
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
            }
            
        } bottomButton: {
            SolidusPrimaryButton(
                title: selectedFileName == nil ? "Select PDF" : "Choose Another PDF",
                action: { isShowingFileImporter = true }
            )
        }
        
        // FILE IMPORTER
        .fileImporter(
            isPresented: $isShowingFileImporter,
            allowedContentTypes: [.pdf],
            allowsMultipleSelection: false
        ) {
            handleFileImport($0)
        }
        
        // LINK STATEMENT PAGE
        .sheet(isPresented: $showLinkView) {
            if let url = importedURL {
                LinkStatementToAccountView(pdfURL: url)
                    .environmentObject(accountsVM)
                    .presentationDetents([ .large ])
            }
        }
    }
}

// FILE LOGIC
private extension ImportStatementView {
    
    func handleFileImport(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            if let url = urls.first {
                importedURL = url
                selectedFileName = url.lastPathComponent
                importError = nil
                showLinkView = true
            }
        case .failure(let error):
            importedURL = nil
            selectedFileName = nil
            importError = "Failed to import file: \(error.localizedDescription)"
        }
    }
}
