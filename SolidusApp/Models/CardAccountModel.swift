//
//  CardAccountModel.swift
//  SolidusApp
//
//  Created by racecar on 11/18/25.
//

import Foundation
import SwiftData

@Model
final class CardAccount {
    
    @Attribute(.unique) var id: UUID
    var cardName: String
    var last4: String
    var nickname: String?
    
    // SNAPSHOT RELATIONSHIP
    @Relationship(deleteRule: .cascade)
    var snapshots: [CardAccountSnapshot]
    
    init(
        cardName: String,
        last4: String,
        nickname: String? = nil
    ) {
        self.id = UUID()
        self.cardName = cardName
        self.last4 = last4
        self.nickname = nickname
        self.snapshots = []
    }
    
    // NAME & NUMBER
    var displayName: String {
        if let nickname, !nickname.isEmpty {
            return "\(nickname) ••••\(last4)"
        }
        return "\(cardName) ••••\(last4)"
    }
}
