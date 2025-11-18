//
//  Item.swift
//  SolidusApp
//
//  Created by racecar on 11/18/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
