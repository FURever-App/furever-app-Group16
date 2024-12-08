//
//  ViewController.swift
//  FinalProject_Group16
//
//  Created by Zhiyu Li on 11/28/24.
//

import UIKit
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {

    let mainScreen = MainScreenView()
    var petsList = [Pet]()
    
    // handle authentication state
    var handleAuth: AuthStateDidChangeListenerHandle?
    var currentUser:FirebaseAuth.User?
    let database = Firestore.firestore()

    override func loadView() {
        view = mainScreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //MARK: handling if the Authentication state is changed (sign in, sign out, register)...
        handleAuth = Auth.auth().addStateDidChangeListener{ auth, user in
            if user == nil{
                //MARK: the user is not signed in...
                self.currentUser = nil
                self.mainScreen.labelText.text = "Please sign in to proceed!"
                self.mainScreen.floatingButtonAddPet.isEnabled = false
                self.mainScreen.floatingButtonAddPet.isHidden = true
                
                self.setupRightBarButton(isLoggedIn: false)

                //MARK: Reset tableView...
                self.petsList.removeAll()
                self.mainScreen.tableViewPets.reloadData()
                
            }else{
                //MARK: the user is signed in...
                self.currentUser = user
                self.mainScreen.labelText.text = "Welcome \(user?.displayName ?? "Anonymous")!"
                self.mainScreen.floatingButtonAddPet.isEnabled = true
                self.mainScreen.floatingButtonAddPet.isHidden = false
                
                self.setupRightBarButton(isLoggedIn: true)
                
                //MARK: Observe Firestore database to display the contacts list...
                self.database.collection("users")
                    .document((self.currentUser?.email)!)
                    .collection("pets")
                    //we observe the "pets" collection of the current user document. If anything is changed in that collection, the closure gets triggered and querySnapshot contains the updates. Basically the querySnapshot contains all the current documents inside the collection we are observing.
                    .addSnapshotListener(includeMetadataChanges: false, listener: {querySnapshot, error in
                        if let documents = querySnapshot?.documents{
                            self.petsList.removeAll()
                            for document in documents{
                                do{
                                    let pet  = try document.data(as: Pet.self)
                                    self.petsList.append(pet)
                                }catch{
                                    print(error)
                                }
                            }
                            self.petsList.sort(by: {$0.name < $1.name})
                            self.mainScreen.tableViewPets.reloadData()
                        }
                    })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //MARK: Make the titles look large...
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Set the navigation bar title
        //self.title = "My Furry Friends"
        
        //MARK: Put the floating button above all the views...
        view.bringSubviewToFront(mainScreen.floatingButtonAddPet)
        mainScreen.floatingButtonAddPet.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        ///
        mainScreen.chatButton.addTarget(self, action: #selector(chatButtonTapped), for: .touchUpInside)
        
        // tap for "map" button
        mainScreen.mapButton.addTarget(self, action: #selector(onMapButtonTapped), for: .touchUpInside)
        
        mainScreen.findDateButton.addTarget(self, action: #selector(onFindDateTapped),for: .touchUpInside)
        mainScreen.tableViewPets.delegate = self
        mainScreen.tableViewPets.dataSource = self
        mainScreen.tableViewPets.separatorStyle = .none
    }

    @objc func floatingButtonTapped() {
        let addPetVC = AddPetViewController()
        navigationController?.pushViewController(addPetVC, animated: true)
    }
    ///
    @objc func chatButtonTapped() {
        let chatPageVC = ChatScreenViewController()
        navigationController?.pushViewController(chatPageVC, animated: true)
    }
    
    // Tap "Map" button ，jump to SwiftUI -  ContentView
    @objc func onMapButtonTapped() {
        let swiftUIView = ContentView()
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        // Push 到当前的 NavigationController 中
        navigationController?.pushViewController(hostingController, animated: true)
    }
    
    
    @objc func onFindDateTapped() {
            guard let currentUser = Auth.auth().currentUser else {
                // Show alert to log in
                let alert = UIAlertController(
                    title: "Login Required",
                    message: "You need to log in to use the 'Find My Date' feature.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { _ in
                    self.navigateToLogin()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true)
                return
            }

            // If the user is logged in, proceed to the profile page
            let profileVC = PetProfileViewController()
            navigationController?.pushViewController(profileVC, animated: true)
        }

        // Navigate to Login Page
        private func navigateToLogin() {
            let loginVC = LoginViewController() // Replace with your login view controller
            navigationController?.pushViewController(loginVC, animated: true)
        }
    }


