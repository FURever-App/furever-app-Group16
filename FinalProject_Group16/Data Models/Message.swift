//
//  Message.swift
//  FinalProject_Group16
//
//  Created by Lu Xu on 12/7/24.
//

import Foundation

struct Message: Codable {
    let text: String
    let uid: String // Sender's ID
    let senderName: String // Sender's name
    let createdAt: Date
    
    private enum CodingKeys: String, CodingKey {
        case text
        case uid = "sender"       // Firebase 中是 "sender"，映射到 uid
        case senderName
        case createdAt = "timestamp" // Firebase 中是 "timestamp"，映射到 createdAt
    }
}
