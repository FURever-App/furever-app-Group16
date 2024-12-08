//
//  DisplayView.swift
//  FinalProject_Group16
//
//  Created by Zhiyu Li on 11/28/24.
//

import UIKit

class DisplayView: UIView {
    var petImageView: UIImageView!
    var stackView: UIStackView!
    var ageLabel: UILabel!
    var sexLabel: UILabel!
    var weightLabel: UILabel!
    var breedLabel: UILabel!
    var colorLabel: UILabel!
    var spayedLabel: UILabel!
    var additionalInfoLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white

        setupPetImageView()
        setupStackView()
        setupLabels()
        initConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupPetImageView() {
        petImageView = UIImageView()
        petImageView.image = UIImage(systemName: "photo") // Placeholder image
        petImageView.contentMode = .scaleAspectFill
        petImageView.clipsToBounds = true
        petImageView.layer.cornerRadius = 75
        petImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(petImageView)
    }

    func setupStackView() {
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
    }

    func setupLabels() {
        ageLabel = createLabel()
        sexLabel = createLabel()
        weightLabel = createLabel()
        breedLabel = createLabel()
        colorLabel = createLabel()
        spayedLabel = createLabel()
        additionalInfoLabel = createLabel()

        stackView.addArrangedSubview(ageLabel)
        stackView.addArrangedSubview(sexLabel)
        stackView.addArrangedSubview(weightLabel)
        stackView.addArrangedSubview(breedLabel)
        stackView.addArrangedSubview(colorLabel)
        stackView.addArrangedSubview(spayedLabel)
        stackView.addArrangedSubview(additionalInfoLabel)
    }

    func createLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "ChalkboardSE-Regular", size: 18) // Cute font for pet app
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func initConstraints() {
        NSLayoutConstraint.activate([
            // Pet Image View
            petImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            petImageView.heightAnchor.constraint(equalToConstant: 150),
            petImageView.widthAnchor.constraint(equalToConstant: 150),
            petImageView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -24),
            
            // Stack View
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -16)
        ])
    }

    func updateLabels(pet: Pet) {
        ageLabel.text = "Age: \(pet.age)"
        sexLabel.text = "Sex: \(pet.sex.rawValue)"
        weightLabel.text = "Weight(lbs): \(pet.weight)"
        breedLabel.text = "Breed: \(pet.breed)"
        colorLabel.text = "Color: \(pet.color)"
        spayedLabel.text = "Spayed/Neutered: \(pet.isSpayedOrNeutered ? "Yes" : "No")"
        additionalInfoLabel.text = pet.additionalInfo?.isEmpty == false ? "Additional Info: \(pet.additionalInfo!)" : "Additional Info: None"
    }
}
