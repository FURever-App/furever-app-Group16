//
//  Chat.swift
//  FinalProject_Group16
//
//  Created by Lu Xu on 12/6/24.
//
//

import Foundation
import FirebaseFirestore

struct Chat: Codable{
    @DocumentID var id: String?
    var dateTime: Date
    var lastMessage: String
    var lastUser: String
    var otherUserEmail: String
    var otherUserName: String
    
    init(dateTime: Date, lastMessage: String, lastUser: String, otherUserEmail: String, otherUserName: String) {
        self.dateTime = dateTime
        self.lastMessage = lastMessage
        self.lastUser = lastUser
        self.otherUserEmail = otherUserEmail.lowercased()
        self.otherUserName = otherUserName
    }
}
