//
//  ChatsTableViewManager.swift
//  FinalProject_Group16
//
//  Created by Lu Xu on 12/7/24.
//
//
import UIKit

extension ChatScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Configs.TableView.chatsCellIdentifier,
            for: indexPath
        ) as? ChatsTableViewCell else {
            fatalError("Cell not registered or of wrong type")
        }
        
        let chat = chatsList[indexPath.row]
        cell.configure(with: chat)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < chatsList.count else { return }
        
        // Get the selected chat
        let selectedChat = chatsList[indexPath.row]
        
        // Navigate to the chat view screen
        let chatDetailVC = ChatViewController()
        chatDetailVC.chatId = selectedChat.id
        chatDetailVC.currentUser = User(
            id: self.currentUser?.email?.lowercased() ?? "",
            name: self.currentUser?.displayName ?? "Me",
            email: self.currentUser?.email?.lowercased() ?? ""
        )
        chatDetailVC.targetUser = User(
            id: selectedChat.otherUserEmail,
            name: selectedChat.otherUserName,
            email: selectedChat.otherUserEmail
        )
        navigationController?.pushViewController(chatDetailVC, animated: true)
    }
}

