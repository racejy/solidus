//
//  PDFManagerModel.swift
//  SolidusApp
//
//  Created by racecar on 11/19/25.
//

import Foundation

struct PDFManager {

    static func savePDFToDocuments(
        originalURL: URL,
        institutionName: String,
        lastFour: String,
        statementDate: Date
    ) throws -> String {

        let fm = FileManager.default
        
        // Folder
        let folder = fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("SolidusStatements")

        if !fm.fileExists(atPath: folder.path) {
            try fm.createDirectory(at: folder, withIntermediateDirectories: true)
        }

        // Format date as YYMMDD
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMdd"
        let datePart = formatter.string(from: statementDate)

        // NAME: {AccountName}{Last4}_{StatementDate}
        let filename = "\(institutionName)\(lastFour)_\(datePart).pdf"

        let dest = folder.appendingPathComponent(filename)

        try fm.copyItem(at: originalURL, to: dest)

        return dest.path
    }
}
