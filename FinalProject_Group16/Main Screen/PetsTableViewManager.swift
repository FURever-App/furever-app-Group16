//
//  PetsTableViewManager.swift
//  FinalProject_Group16
//
//  Created by Zhiyu Li on 11/28/24.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pets", for: indexPath) as! PetsTableViewCell
        let pet = petsList[indexPath.row]
        cell.updateWithPet(pet: pet)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pet = petsList[indexPath.row] // Get the selected pet
        let detailsVC = DisplayViewController()
        detailsVC.pet = pet // Pass the selected pet to the details screen
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    // swipe to delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Create a delete action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            self.deleteSelectedFor(petIndex: indexPath.row)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        deleteAction.image = UIImage(systemName: "trash")

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    
    func deleteSelectedFor(petIndex: Int) {
        // Get the selected pet
        let petToDelete = petsList[petIndex]
        
        // Check if the pet has a valid Firestore ID
        guard let petID = petToDelete.id, let userEmail = Auth.auth().currentUser?.email else {
            print("Pet ID or user email is missing. Cannot delete pet.")
            return
        }

        // Reference to the pet document in Firestore
        let petDoc = Firestore.firestore()
            .collection("users")
            .document(userEmail)
            .collection("pets")
            .document(petID)

        // Show a confirmation alert before deletion
        let alert = UIAlertController(
            title: "Delete Pet",
            message: "Are you sure you want to delete \(petToDelete.name)? This action cannot be undone.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }

            // Delete the pet from Firestore
            petDoc.delete { error in
                if let error = error {
                    print("Failed to delete pet from Firestore: \(error.localizedDescription)")
                    Utils.showAlert(on: self, title: "Error", message: "Failed to delete pet. Please try again.")
                } else {
                    print("Pet deleted successfully from Firestore")
                    
                    Utils.deleteOldImageFromStorage(oldImageURL: petToDelete.photoURL)

                    self.fetchPetsFromFirestore()

                    // Show a success message
                    Utils.showAlert(on: self, title: "Success", message: "Pet deleted successfully.")
                }
            }
        }))
        
        // Present the confirmation alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchPetsFromFirestore() {
        guard let userEmail = Auth.auth().currentUser?.email else { return }

        Firestore.firestore()
            .collection("users")
            .document(userEmail)
            .collection("pets")
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("Failed to fetch pets: \(error.localizedDescription)")
                } else {
                    self.petsList = snapshot?.documents.compactMap { try? $0.data(as: Pet.self) } ?? []
                    self.mainScreen.tableViewPets.reloadData()
                }
            }
    }
}
