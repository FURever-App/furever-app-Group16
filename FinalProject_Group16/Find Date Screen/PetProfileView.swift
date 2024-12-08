//
//  PetProfileView.swift
//  FinalProject_Group16
//
//  Created by Huining Yu on 12/7/24.
//

import UIKit

class PetProfileView: UIView {
    // UI Elements
    private let titleLabel = UILabel()
    private let petImageView = UIImageView()
    private let petNameLabel = UILabel()
    private let petBreedLabel = UILabel()
    private let petAgeLabel = UILabel()
    private let petWeightLabel = UILabel()
    private let infoStackView = UIStackView()
    let makeFriendsButton = UIButton(type: .system)
    let nextButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let buttonStackView = UIStackView()

    private func setupUI() {
        titleLabel.text = "Furever Friends"
        titleLabel.font = UIFont(name: "Modak", size: 34)
        titleLabel.textColor = .white
            titleLabel.textAlignment = .center
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            addSubview(titleLabel)
        
        backgroundColor = UIColor(
            red: 207 / 255.0,
            green: 178 / 255.0,
            blue: 159 / 255.0,
            alpha: 1.0
        )
        // Pet Image View
        petImageView.contentMode = .scaleAspectFill
        petImageView.clipsToBounds = true
        petImageView.layer.cornerRadius = 20
        petImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(petImageView)

        // Info Stack View
        infoStackView.axis = .vertical
        infoStackView.alignment = .center
        infoStackView.spacing = 8
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(infoStackView)

        // Pet Name Label
        petNameLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 28)
        petNameLabel.textColor = .white
        petNameLabel.numberOfLines = 1
        infoStackView.addArrangedSubview(petNameLabel)

        // Pet Breed Label
        petBreedLabel.font = UIFont(name: "ChalkboardSE-Regular", size: 20)
        petBreedLabel.textColor = .white
        petBreedLabel.numberOfLines = 1
        infoStackView.addArrangedSubview(petBreedLabel)

        // Pet Age Label
        petAgeLabel.font = UIFont(name: "ChalkboardSE-Regular", size: 20)
        petAgeLabel.textColor = .white
        petAgeLabel.numberOfLines = 1
        infoStackView.addArrangedSubview(petAgeLabel)

        // Pet Weight Label
        petWeightLabel.font = UIFont(name: "ChalkboardSE-Regular", size: 20)
        petWeightLabel.textColor = .white
        petWeightLabel.numberOfLines = 1
        infoStackView.addArrangedSubview(petWeightLabel)

        // Buttons: Make Friends and Next
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 16
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonStackView)

        // Add buttons to the stack view
        makeFriendsButton.setTitle("Be My Friend!", for: .normal)
        makeFriendsButton.setTitleColor(.white, for: .normal)
        makeFriendsButton.titleLabel?.font = UIFont(name: "Modak", size: 24)
        makeFriendsButton.backgroundColor = UIColor(
            red: 207 / 255.0,
            green: 178 / 255.0,
            blue: 159 / 255.0,
            alpha: 1.0
        )
        makeFriendsButton.layer.cornerRadius = 12
        makeFriendsButton.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.addArrangedSubview(makeFriendsButton)

        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "Modak", size: 24)
        nextButton.backgroundColor = UIColor(
            red: 207 / 255.0,
            green: 178 / 255.0,
            blue: 159 / 255.0,
            alpha: 1.0
        )
        nextButton.layer.cornerRadius = 12
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.addArrangedSubview(nextButton)

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant:8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            // Pet Image View
            petImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            petImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            petImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            petImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),

            // Info Stack View
            infoStackView.leadingAnchor.constraint(equalTo: petImageView.leadingAnchor, constant: 16),
            infoStackView.trailingAnchor.constraint(equalTo: petImageView.trailingAnchor, constant: -16),
            infoStackView.bottomAnchor.constraint(equalTo: petImageView.bottomAnchor, constant: -16),

            // Button Stack View
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            buttonStackView.heightAnchor.constraint(equalToConstant: 50),
            buttonStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -32),
        ])
    }
    // Method to update the view with pet data
    func updateView(with pet: Pet) {
        // Load pet image
        petImageView.loadImage(from: pet.photoURL, placeholder: UIImage(systemName: "photo"))
        
        // Update text for labels
        petNameLabel.text = pet.name
        petBreedLabel.text = "I am a \(pet.breed)"
        petAgeLabel.text = "I am now \(pet.age) years old"
        petWeightLabel.text = "I weighed \(pet.weight) lbs"
    }
}

extension UIImageView {
    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
        // Set the placeholder image first
        self.image = placeholder
        
        // Validate the URL string
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        // Fetch the image data asynchronously
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // Ensure no errors and valid data
            guard let self = self, let data = data, error == nil else {
                print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Create the image and set it on the main thread
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                print("Failed to create image from data.")
            }
        }.resume()
    }
}
