//
//  PDFTextExtractorModel.swift
//  SolidusApp
//
//  Created by racecar on 11/20/25.
//

import Foundation
import PDFKit

enum PDFExtractionError: Error {
    case invalidPDF
}

struct PDFTextExtractor {

    static func extractText(from url: URL) throws -> String {
        guard let pdf = PDFDocument(url: url) else {
            throw PDFExtractionError.invalidPDF
        }

        var result = ""

        for i in 0..<pdf.pageCount {
            if let page = pdf.page(at: i),
               let text = page.string {
                result += "\n" + text
            }
        }

        return result
    }
}
