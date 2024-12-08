//
//  DisplayViewController.swift
//  FinalProject_Group16
//
//  Created by Zhiyu Li on 11/28/24.
//
import UIKit

class DisplayViewController: UIViewController {
    let petDetailsView = DisplayView()
    var pet: Pet!

    override func loadView() {
        self.view = petDetailsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the dynamic title based on the pet type
        if pet.type == .dog {
            self.title = "\(pet.name) is a dog!"
        } else if pet.type == .cat {
            self.title = "\(pet.name) is a cat!"
        }

        // Update the labels with pet details
        petDetailsView.updateLabels(pet: pet)

        // Add the Edit button to the navigation bar
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItem = editButton

        // Load the pet image from the URL
        if let imageURL = URL(string: pet.photoURL) {
            loadImage(from: imageURL)
        }
    }

    @objc func editButtonTapped() {
        // Create an instance of AddPetViewController
        let editPetVC = EditViewController()
        
        // Pass the existing pet data to the AddPetViewController
        editPetVC.pet = pet
        editPetVC.delegateToDisplay = self
                
        // Push the AddPetViewController to the navigation stack
        navigationController?.pushViewController(editPetVC, animated: true)
    }
    
    func reload(pet: Pet) {
        // Update labels
        petDetailsView.updateLabels(pet: pet)
        
        // Update the image
        if let url = URL(string: pet.photoURL) {
            loadImage(from: url)
        }
    }

    func loadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self, let data = data, error == nil else {
                print("Failed to load pet image")
                return
            }
            DispatchQueue.main.async {
                self.petDetailsView.petImageView.image = UIImage(data: data)
            }
        }
        task.resume()
    }
}
