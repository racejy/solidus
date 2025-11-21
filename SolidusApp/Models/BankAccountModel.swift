//
//  BankAccountModel.swift
//  SolidusApp
//
//  Created by racecar on 11/18/25.
//

import Foundation
import SwiftData

@Model
final class BankAccount {
    
    @Attribute(.unique) var id: UUID
    var bankName: String
    var last4: String
    var nickname: String?
    
    // SNAPSHOTS RELATIONSHIP
    @Relationship(deleteRule: .cascade)
    var snapshots: [BankAccountSnapshot]
    
    init(
        bankName: String,
        last4: String,
        nickname: String? = nil
    ) {
        self.id = UUID()
        self.bankName = bankName
        self.last4 = last4
        self.nickname = nickname
        self.snapshots = []
    }
    
    // NAME & NUMBER
    var displayName: String {
        if let nickname, !nickname.isEmpty {
            return "\(nickname) ••••\(last4)"
        }
        return "\(bankName) ••••\(last4)"
    }
}
