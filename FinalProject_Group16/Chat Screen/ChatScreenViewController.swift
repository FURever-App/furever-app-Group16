//
//  ChatViewController.swift
//  FinalProject_Group16
//
//  Created by Lu Xu on 12/6/24.
//
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatScreenViewController: UIViewController {
    var chatsList = [Chat]()
    private let database = Firestore.firestore()
    private let chatScreen = ChatScreenView()
    private var handleAuth: AuthStateDidChangeListenerHandle?
    var currentUser: FirebaseAuth.User?

    override func loadView() {
        view = chatScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        navigationController?.navigationBar.prefersLargeTitles = true
        
        chatScreen.tableViewChats.delegate = self
        chatScreen.tableViewChats.dataSource = self
        fetchChats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleAuth = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            self.currentUser = user
            if user == nil {
                self.chatsList.removeAll()
                self.chatScreen.tableViewChats.reloadData()
            } else {
                self.fetchChats()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let handleAuth = handleAuth {
            Auth.auth().removeStateDidChangeListener(handleAuth)
        }
    }
    
    private func fetchChats() {
        guard let email = currentUser?.email else {
            print("User is not logged in.")
            return
        }
        
        let userID = email.lowercased()
        database.collection("users").document(userID).collection("chats")
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching chats: \(error.localizedDescription)")
                    return
                }
                
                self.chatsList = querySnapshot?.documents.compactMap {
                    try? $0.data(as: Chat.self)
                } ?? []
                self.chatsList.sort(by: { $0.dateTime > $1.dateTime })
                DispatchQueue.main.async {
                    self.chatScreen.tableViewChats.reloadData()
                }
            }
    }
}
