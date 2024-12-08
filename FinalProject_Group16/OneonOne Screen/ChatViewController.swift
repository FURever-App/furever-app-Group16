//
//  ChatViewController.swift
//  FinalProject_Group16
//
//  Created by Lu Xu on 12/7/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var chatId: String? // Unique chat ID
    var targetUser: User? // Target user for one-on-one chat
    var currentUser: User? // Current logged-in user
    var messages = [Message]() // Stores chat messages
    let chatView = ChatView() // Custom chat view
    let db = Firestore.firestore()
    let mainScreen = MainScreenView()
    var chatsList = [Chat]()
    override func loadView() {
        view = chatView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatView.tableView.delegate = self
        chatView.tableView.dataSource = self
        chatView.sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
//        title = targetUser?.name
        
        /// Set the navigation title
        navigationItem.title = targetUser?.name ?? "Chat"

        // Customize the font and appearance
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .font: UIFont(name: "DeliusUnicase", size: 25) ?? UIFont.systemFont(ofSize: 25),
            .foregroundColor: UIColor(
                red: 130 / 255.0, // Reduced from 207
                green: 118 / 255.0, // Reduced from 178
                blue: 110 / 255.0, // Reduced from 159
                alpha: 1.0 // Fully opaque
            )
        ]

        // Apply the appearance
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        // Add keyboard observers for input field adjustment
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        loadChatMessages()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self) // Remove observers on deinit
    }
    
    func loadChatMessages() {
        guard let chatId = chatId else { return }
        
        db.collection("chats").document(chatId).collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "")")
                    return
                }
                
                self.messages = documents.compactMap { document in
                    return try? document.data(as: Message.self)
                }
                
                print("Loaded messages: \(self.messages)") // Debug message
                self.chatView.tableView.reloadData()
                self.scrollToBottom()
            }
    }
    
    @objc private func sendMessage() {
        guard let chatId = chatId,
              let currentUser = currentUser,
              let messageText = chatView.messageInputField.text,
              !messageText.isEmpty else { return }
        let timestamp = Timestamp()
        let newMessage = [
            "sender": currentUser.email,             // 用于 sender ID
            "senderName": currentUser.name,          // 用于 sender name
            "text": messageText,
            "timestamp": timestamp
        ] as [String : Any]
        
         db.collection("chats")
            .document(chatId)
            .collection("messages")
            .addDocument(data: newMessage) { error in
            if let error = error {
                print("Failed to send message: \(error.localizedDescription)")
            } else {
                print("Message sent successfully") // Debug message
                self.chatView.messageInputField.text = ""
            }
        }
        var referenceData: [String: Any] = [
            "dateTime": timestamp.dateValue(),
            "lastMessage": messageText,
            "lastUser": currentUser.name,
            "otherUserEmail": targetUser!.email,
            "otherUserName": targetUser!.name]
        db.collection("users")
            .document(currentUser.email)
           .collection("chats")
           .document(chatId).setData(referenceData) { error in
           if let error = error {
               print("Failed to send message: \(error.localizedDescription)")
           } else {
               print("Message sent successfully") // Debug message
               self.chatView.messageInputField.text = ""
           }
       }
        referenceData["otherUserEmail"] = currentUser.email
        referenceData["otherUserName"] = currentUser.name
        
        
        db.collection("users")
            .document(targetUser!.email)
           .collection("chats")
           .document(chatId).setData(referenceData) { error in
           if let error = error {
               print("Failed to send message: \(error.localizedDescription)")
           } else {
               print("Message sent successfully") // Debug message
               self.chatView.messageInputField.text = ""
           }
       }
        
        
        // listening to changes in the chats subcollection

        self.db.collection("chats")
            .document(chatId)
            .collection("messages")
            .addSnapshotListener(includeMetadataChanges: false) { querySnapshot, error in
                if let error = error {
                    print("Error fetching chat documents: \(error)")
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    print("No documents found in chats collection")
                    return
                }

                self.chatsList.removeAll()
                for document in documents {
                    do {
                        let chat = try document.data(as: Chat.self)
                        self.chatsList.append(chat)
                    } catch {
                        print("Error decoding chat document: \(error)")
                    }
                }
                
                if !self.chatsList.isEmpty {
                    self.chatsList.sort(by: { $0.otherUserName < $1.otherUserName })
                }
                
//                DispatchQueue.main.async {
//                    self.mainScreen.tableViewChats.reloadData()
//                }
            }


    }

    private func scrollToBottom() {
        guard messages.count > 0 else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        chatView.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            chatView.tableView.contentInset.bottom = keyboardFrame.height + 10
        }

    @objc func keyboardWillHide(_ notification: Notification) {
        chatView.tableView.contentInset.bottom = 0
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        if message.uid == currentUser?.id {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OutgoingMessageCell", for: indexPath) as! OutgoingMessageCell
            cell.configure(with: message)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncomingMessageCell", for: indexPath) as! IncomingMessageCell
            cell.configure(with: message)
            return cell
        }
    }
}


