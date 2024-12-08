//
//  ChatManager.swift
//  FinalProject_Group16
//
//  Created by Lu Xu on 12/7/24.
//

import Foundation
import FirebaseFirestore
import Combine

class ChatManager {
    
    static let shared = ChatManager()
    
    private let database = Firestore.firestore()
    var updatedMessagesPublisher = PassthroughSubject<[Message], Error>()
    
    private init() {}
    
    func fetchMessages(forChatID chatID: String) async throws -> [Message] {
        let snapshot = try await database.collection("chats").document(chatID).collection("messages").order(by: "createdAt", descending: true).limit(to: 25).getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Message.self) }.reversed()
    }
    
    func sendMessage(message: Message, toChatID chatID: String) {
        let messageData: [String: Any] = [
            "text": message.text,
            "uid": message.uid,
            "createdAt": Timestamp(date: message.createdAt)
        ]
        database.collection("chats").document(chatID).collection("messages").addDocument(data: messageData)
        database.collection("users").document().updateData(["lastMessage": messageData])
    }
    
    func listenToChangesInChat(chatID: String) {
        database.collection("chats").document(chatID).collection("messages")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents, error == nil else { return }
                let messages = documents.compactMap { try? $0.data(as: Message.self) }.reversed()
                self?.updatedMessagesPublisher.send(Array(messages))
            }
    }
    
    func generateChatID(forUser uid1: String, andUser uid2: String) -> String {
        return uid1.lowercased() < uid2.lowercased() ? "\(uid1.lowercased())_\(uid2.lowercased())" : "\(uid2.lowercased())_\(uid1.lowercased())"
        
    }
}
