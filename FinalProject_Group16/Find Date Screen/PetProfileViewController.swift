//
//  PetProfileViewController.swift
//  FinalProject_Group16
//
//  Created by Huining Yu on 12/7/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class PetProfileViewController: UIViewController {
    
    private let profileView = PetProfileView()
    private var pets: [Pet] = []
    private var currentIndex = 0
    private var currentUser: FirebaseAuth.User?
    private var targetUser: User?
    private let database = Firestore.firestore()
    private var handleAuth: AuthStateDidChangeListenerHandle?

    override func loadView() {
        self.view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        fetchPetsFromFirestore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handleAuth = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            self.currentUser = user
            if user == nil {
                self.showLoginMessage()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let handleAuth = handleAuth {
            Auth.auth().removeStateDidChangeListener(handleAuth)
        }
    }
    
    private func setupActions() {
        profileView.makeFriendsButton.addTarget(self, action: #selector(onMakeFriendsTapped), for: .touchUpInside)
        profileView.nextButton.addTarget(self, action: #selector(onNextTapped), for: .touchUpInside)
    }
    
    private func fetchPetsFromFirestore() {
        database.collectionGroup("pets").getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching pets: \(error.localizedDescription)")
                self.displayNoPetsMessage()
                return
            }
            
            self.pets = snapshot?.documents.compactMap { doc in
                try? doc.data(as: Pet.self)
            }.filter { $0.ownerEmail != self.currentUser?.email } ?? []
            
            if self.pets.isEmpty {
                self.displayNoPetsMessage()
            } else {
                self.displayCurrentPet()
            }
        }
    }

    private func fetchUserFromFirestore(userID: String) async throws -> User {
        let snapshot = try await database.collection("users").document(userID).getDocument()
        
        // Ensure the document exists
        guard snapshot.exists else {
            throw NSError(domain: "UserFetchingError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])
        }
        
        // Fetch the username from the document
        if let username = snapshot.get("name") as? String {
            return User(id: userID.lowercased(), name: username, email: userID.lowercased())
        } else {
            throw NSError(domain: "UserFetchingError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User name not found in document"])
        }
    }


    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }




    
    private func displayCurrentPet() {
        guard currentIndex < pets.count else {
            displayNoPetsMessage()
            return
        }
        
        let pet = pets[currentIndex]
        profileView.updateView(with: pet)
        updateButtonStates()
    }
    
    private func displayNoPetsMessage() {
        profileView.makeFriendsButton.isHidden = true
        profileView.nextButton.isHidden = true
        
        let label = UILabel()
        label.text = "No more pets to display."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func updateButtonStates() {
        profileView.makeFriendsButton.isHidden = pets.isEmpty
        profileView.nextButton.isHidden = pets.isEmpty || currentIndex >= pets.count - 1
    }
    
    private func showLoginMessage() {
        let alert = UIAlertController(
            title: "Login Required",
            message: "Please log in to view pet profiles.",
            preferredStyle: .alert
        )
        let loginAction = UIAlertAction(title: "Login", style: .default) { _ in
            // Navigate to login screen
        }
        alert.addAction(loginAction)
        present(alert, animated: true)
    }
    
    @objc private func onMakeFriendsTapped() {
        guard currentIndex < pets.count else { return }
        let pet = pets[currentIndex]
        
        print("You made friends with \(pet.name ?? "Unknown")!")
        
        guard let ownerEmail = pet.ownerEmail else {
            print("Error: Pet owner email is nil!")
            return
        }
        
        Task {
            do {
                // Fetch the target user asynchronously
                let fetchedUser = try await fetchUserFromFirestore(userID: ownerEmail)
                self.targetUser = fetchedUser
                
                // Navigate to the chat screen after successfully fetching the user
                let chatVC = ChatViewController()
                chatVC.chatId = ChatManager.shared.generateChatID(
                    forUser: self.currentUser?.email ?? "",
                    andUser: ownerEmail
                )
                chatVC.currentUser = User(
                    id: self.currentUser?.email?.lowercased() ?? "",
                    name: self.currentUser?.displayName ?? "Me",
                    email: self.currentUser?.email?.lowercased() ?? ""
                )
                chatVC.targetUser = fetchedUser
                
                navigationController?.pushViewController(chatVC, animated: true)
            } catch {
                // Handle errors gracefully
                print("Failed to fetch user for email \(ownerEmail): \(error.localizedDescription)")
                showAlert(title: "Error", message: "Could not fetch user information. Please try again.")
            }
        }
    }

    
//    @objc private func onMakeFriendsTapped() async {
//        guard currentIndex < pets.count else { return }
//        let pet = pets[currentIndex]
//        print("You made friends with \(pet.name)!")
//        
// //Save friendship in Firestore or perform other actions
//        let chatVC = ChatViewController()
//        // Configure chat ID and user details
//        chatVC.chatId = ChatManager.shared.generateChatID(forUser: currentUser?.email ?? "", andUser: pet.ownerEmail!)
//        chatVC.currentUser = User(id: currentUser?.email ?? "", name: currentUser?.displayName ?? "Me", email: currentUser?.email ?? "")
//
//        self.targetUser = try? await fetchUserFromFirestore( userID: pet.ownerEmail!)
//
//        navigationController?.pushViewController(chatVC, animated: true)
    
    

        // Perform actions to save friendship in Firestore
        // Navigate to a chat screen if applicable
        // Create or retrieve the chat ID for the current user and pet owner
//        let petOwnerEmail = pet.ownerEmail
//        let chatID = generateChatID(forUser: currentUser.email ?? "", andUser: petOwnerEmail)
//            
//            // Navigate to the chat screen
//        let chatVC = ChatViewController()
//        chatVC.chatId = chatID
//        chatVC.currentUser = User(
//            id: currentUser.uid,
//            name: currentUser.displayName ?? "Me",
//            email: currentUser.email ?? ""
//        )
//        chatVC.targetUser = User(
//            id: petOwnerEmail,  // Assuming owner's email is unique
//            name: pet.ownerName ?? "Unknown",  // Pet owner's name
//            email: petOwnerEmail
//        )
//            
//        navigationController?.pushViewController(chatVC, animated: true)
//    }
    
    @objc private func onNextTapped() {
        currentIndex += 1
        if currentIndex < pets.count {
            displayCurrentPet()
        } else {
            currentIndex = pets.count - 1 // Ensure index doesn't exceed bounds
            showAlertNoMorePets()
        }
    }

    private func showAlertNoMorePets() {
        let alert = UIAlertController(
            title: "End of List",
            message: "That's all the pets we have!",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}




//
//import UIKit
//import FirebaseFirestore
//import FirebaseAuth
//
//class PetProfileViewController: UIViewController {
//    private let profileView = PetProfileView()
//    private var pets: [Pet] = []
//    private var currentIndex = 0
//    var currentUser: FirebaseAuth.User?
//    let database = Firestore.firestore()
//    var handleAuth: AuthStateDidChangeListenerHandle?
//
//    override func loadView() {
//        self.view = profileView
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        handleAuth = Auth.auth().addStateDidChangeListener { auth, user in
//            if user == nil {
//                self.currentUser = nil
//                self.mainScreen.labelText.text = "Please sign in to see the chats!"
//                self.mainScreen.floatingButtonNewChat.isEnabled = false
//                self.mainScreen.floatingButtonNewChat.isHidden = true
//                self.setupRightBarButton(isLoggedin: false)
//                self.chatsList.removeAll()
//                self.mainScreen.tableViewChats.reloadData()
//            } else {
//                self.currentUser = user
//                self.mainScreen.labelText.text = "Welcome \(user?.displayName ?? "Anonymous")!"
//                self.mainScreen.floatingButtonNewChat.isEnabled = true
//                self.mainScreen.floatingButtonNewChat.isHidden = false
//                self.setupRightBarButton(isLoggedin: true)
//                let originalEmail = (self.currentUser?.email)!
//                let userID = originalEmail.prefix(1).uppercased() + originalEmail.dropFirst()
//                self.database.collection("users")
//                    .document(userID)
//                    .collection("chats")
//                    .addSnapshotListener(includeMetadataChanges: false, listener: {querySnapshot, error in
//                        if let documents = querySnapshot?.documents{
//                            self.chatsList.removeAll()
//                            for document in documents{
//                                do{
//                                    let chats  = try document.data(as: Chat.self)
//                                    self.chatsList.append(chats)
//                                }catch{
//                                    print(error)
//                                }
//                            }
//                            self.chatsList.sort(by: {$0.dateTime > $1.dateTime})
//                            self.mainScreen.tableViewChats.reloadData()
//                        }
//                    })
//            }
//        }
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupActions()
//        fetchPetsFromFirestore()
//    }
//    
//    private func setupActions() {
//        profileView.makeFriendsButton.addTarget(self, action: #selector(onMakeFriendsTapped), for: .touchUpInside)
//        profileView.nextButton.addTarget(self, action: #selector(onNextTapped), for: .touchUpInside)
//    }
//    
//    private func fetchPetsFromFirestore() {
//        let db = Firestore.firestore()
//        
//        db.collectionGroup("pets").getDocuments { [weak self] snapshot, error in
//            guard let self = self else { return }
//            
//            if let error = error {
//                print("Error fetching pets: \(error.localizedDescription)")
//                self.displayNoPetsMessage()
//                return
//            }
//            
//            self.pets = snapshot?.documents.compactMap { doc in
//                print("Fetched pet: \(doc.data())") // Debug log
//                return try? doc.data(as: Pet.self)
//            } ?? []
//            
//            self.pets = self.pets.filter { $0.ownerEmail != Auth.auth().currentUser?.email } // Exclude current user
//            
//            if self.pets.isEmpty {
//                print("No pets available.")
//                self.displayNoPetsMessage()
//            } else {
//                print("Fetched \(self.pets.count) pets.")
//                self.displayCurrentPet()
//            }
//        }
//    }
//    
//    private func displayCurrentPet() {
//        guard currentIndex < pets.count else {
//            displayNoPetsMessage()
//            return
//        }
//        
//        let pet = pets[currentIndex]
//        profileView.updateView(with: pet)
//        print("Displaying pet: \(pet.name)")
//    }
//    
//    private func displayNoPetsMessage() {
//        let label = UILabel()
//        label.text = "No more pets to display."
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(label)
//        
//        NSLayoutConstraint.activate([
//            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
//    
//    @objc private func onMakeFriendsTapped() {
//        guard currentIndex < pets.count else { return }
//        let pet = pets[currentIndex]
//        print("You made friends with \(pet.name)!")
//        
//        // Save friendship in Firestore or perform other actions
//        let chatVC = ChatViewController()
//        // Configure chat ID and user details
//        chatVC.chatId = ChatManager.shared.generateChatID(forUser: currentUser?.email ?? "", andUser: user.email)
//        chatVC.currentUser = User(id: currentUser?.email ?? "", name: currentUser?.displayName ?? "Me", email: currentUser?.email ?? "")
//        chatVC.targetUser = user
//        navigationController?.pushViewController(chatVC, animated: true)
//        
//    }
//    
//    @objc private func onNextTapped() {
//        currentIndex += 1
//        
//        if currentIndex < pets.count {
//            // Display the next pet in the list
//            displayCurrentPet()
//        } else {
//            // Show an alert indicating no more pets
//            currentIndex = pets.count - 1 // Ensure index doesn't exceed bounds
//            showAlertNoMorePets()
//        }
//    }
//
//    private func showAlertNoMorePets() {
//        let alert = UIAlertController(
//            title: "End of List",
//            message: "That's all the pets we have!",
//            preferredStyle: .alert
//        )
//        
//        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(okAction)
//        
//        present(alert, animated: true)
//    }
//}
