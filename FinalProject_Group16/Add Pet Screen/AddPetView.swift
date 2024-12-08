//
//  AddPetView.swift
//  FinalProject_Group16
//
//  Created by Zhiyu Li on 11/28/24.
//

import UIKit

class AddPetView: UIView {
    
    var contentWrapper: UIScrollView!
    var titleLabel: UILabel!
    var uploadPhotoButton: UIButton!
    var dogButton: UIButton!
    var catButton: UIButton!
    var nameTextField: UITextField!
    var ageTextField: UITextField!
    var sexLabel: UILabel!
    var sexDropdown: UIButton!
    var weightTextField: UITextField!
    var breedTextField: UITextField!
    var colorTextField: UITextField!
    var spayedLabel: UILabel!
    var spayedDropdown: UIButton!
    var additionalInfoTextField: UITextField!
    var saveButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupContentWrapper()
        setupTitleLabel()
        setupUploadPhotoButton()
        setupPetTypeButtons()
        setupNameTextField()
        setupAgeField()
        setupSexDropdown()
        setupSpayedNeuteredDropdown()
        setupAdditionalFields()
        setupSaveButton()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContentWrapper(){
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
    }
    
    func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "Add a New Pet"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(titleLabel)
    }
    
    func setupUploadPhotoButton() {
        uploadPhotoButton = UIButton(type: .system)
        uploadPhotoButton.setTitle("Upload Pet Photo", for: .normal)
        uploadPhotoButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        uploadPhotoButton.backgroundColor = .lightGray
        uploadPhotoButton.layer.cornerRadius = 50
        uploadPhotoButton.clipsToBounds = true
        uploadPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(uploadPhotoButton)
    }
    
    func setupPetTypeButtons() {
        dogButton = UIButton(type: .system)
        dogButton.setTitle("Dog", for: .normal)
        dogButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        dogButton.backgroundColor = UIColor(
            red: 207/255.0,
            green: 178/255.0,
            blue: 159/255.0,
            alpha: 255/255.0)
        dogButton.setTitleColor(.white, for: .normal)
        dogButton.layer.cornerRadius = 10
        dogButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(dogButton)
        
        catButton = UIButton(type: .system)
        catButton.setTitle("Cat", for: .normal)
        catButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        catButton.backgroundColor = UIColor(
            red: 207/255.0,
            green: 178/255.0,
            blue: 159/255.0,
            alpha: 255/255.0)
        catButton.setTitleColor(.white, for: .normal)
        catButton.layer.cornerRadius = 10
        catButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(catButton)
    }
    
    func setupNameTextField() {
        nameTextField = UITextField()
        nameTextField.placeholder = "Name"
        nameTextField.borderStyle = .roundedRect
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(nameTextField)
    }
    
    func setupAgeField() {
        ageTextField = UITextField()
        ageTextField.placeholder = "Age"
        ageTextField.keyboardType = .numberPad
        ageTextField.borderStyle = .roundedRect
        ageTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(ageTextField)
    }
    
    func setupSexDropdown() {
        // Label for Sex
        sexLabel = UILabel()
        sexLabel.text = "Sex"
        sexLabel.font = UIFont.boldSystemFont(ofSize: 16)
        sexLabel.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(sexLabel)

        // Dropdown button
        sexDropdown = UIButton(type: .system)
        sexDropdown.setTitle("Select", for: .normal)
        sexDropdown.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        sexDropdown.backgroundColor = UIColor(
            red: 207/255.0,
            green: 178/255.0,
            blue: 159/255.0,
            alpha: 255/255.0)
        sexDropdown.setTitleColor(.white, for: .normal)
        sexDropdown.layer.cornerRadius = 8
        sexDropdown.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(sexDropdown)

        // Create UIMenu
        let maleAction = UIAction(title: "Male", handler: { _ in
            self.sexDropdown.setTitle("Male", for: .normal)
        })
        let femaleAction = UIAction(title: "Female", handler: { _ in
            self.sexDropdown.setTitle("Female", for: .normal)
        })

        sexDropdown.menu = UIMenu(title: "", options: .displayInline, children: [maleAction, femaleAction])
        sexDropdown.showsMenuAsPrimaryAction = true
    }
    
    func setupSpayedNeuteredDropdown() {
        // Label for Spayed/Neutered
        spayedLabel = UILabel()
        spayedLabel.text = "Spayed/Neutered?"
        spayedLabel.font = UIFont.boldSystemFont(ofSize: 16)
        spayedLabel.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(spayedLabel)

        // Dropdown button
        spayedDropdown = UIButton(type: .system)
        spayedDropdown.setTitle("Select", for: .normal)
        spayedDropdown.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        spayedDropdown.backgroundColor = UIColor(
            red: 207/255.0,
            green: 178/255.0,
            blue: 159/255.0,
            alpha: 255/255.0)
        spayedDropdown.setTitleColor(.white, for: .normal)
        spayedDropdown.layer.cornerRadius = 8
        spayedDropdown.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(spayedDropdown)

        // Create UIMenu
        let yesAction = UIAction(title: "Yes", handler: { _ in
            self.spayedDropdown.setTitle("Yes", for: .normal)
        })
        let noAction = UIAction(title: "No", handler: { _ in
            self.spayedDropdown.setTitle("No", for: .normal)
        })

        spayedDropdown.menu = UIMenu(title: "", options: .displayInline, children: [yesAction, noAction])
        spayedDropdown.showsMenuAsPrimaryAction = true
    }
    
    func setupAdditionalFields() {
        weightTextField = UITextField()
        weightTextField.placeholder = "Weight (lbs)"
        weightTextField.keyboardType = .numberPad
        weightTextField.borderStyle = .roundedRect
        weightTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(weightTextField)
        
        breedTextField = UITextField()
        breedTextField.placeholder = "Breed"
        breedTextField.borderStyle = .roundedRect
        breedTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(breedTextField)
        
        colorTextField = UITextField()
        colorTextField.placeholder = "Color"
        colorTextField.borderStyle = .roundedRect
        colorTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(colorTextField)
        
        additionalInfoTextField = UITextField()
        additionalInfoTextField.placeholder = "Additional Information"
        additionalInfoTextField.borderStyle = .roundedRect
        additionalInfoTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(additionalInfoTextField)
    }
    
    func setupSaveButton() {
        saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        saveButton.backgroundColor = UIColor(red: 207/255, green: 178/255, blue: 159/255, alpha: 1) // Dark beige color
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(saveButton)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView Constraints
            contentWrapper.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentWrapper.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentWrapper.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            // Title Label
            titleLabel.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),

            // Upload Photo Button
            uploadPhotoButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            uploadPhotoButton.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            uploadPhotoButton.widthAnchor.constraint(equalTo: contentWrapper.widthAnchor, multiplier: 0.4), // 40% of screen width
            uploadPhotoButton.heightAnchor.constraint(equalTo: uploadPhotoButton.widthAnchor), // Keeps it square

            // Pet Type Buttons
            dogButton.topAnchor.constraint(equalTo: uploadPhotoButton.bottomAnchor, constant: 24),
            dogButton.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 16),
            dogButton.trailingAnchor.constraint(equalTo: contentWrapper.centerXAnchor, constant: -8),
            dogButton.heightAnchor.constraint(equalToConstant: 50),

            catButton.topAnchor.constraint(equalTo: dogButton.topAnchor),
            catButton.leadingAnchor.constraint(equalTo: contentWrapper.centerXAnchor, constant: 8),
            catButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            catButton.heightAnchor.constraint(equalToConstant: 50),

            // Name TextField
            nameTextField.topAnchor.constraint(equalTo: dogButton.bottomAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),

            // Age TextField
            ageTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            ageTextField.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 16),
            ageTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),

            // Sex Label
            sexLabel.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: 16),
            sexLabel.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 16),

            // Sex Dropdown
            sexDropdown.topAnchor.constraint(equalTo: sexLabel.bottomAnchor, constant: 8),
            sexDropdown.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 16),
            sexDropdown.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            sexDropdown.heightAnchor.constraint(equalToConstant: 40),

            // Weight TextField
            weightTextField.topAnchor.constraint(equalTo: sexDropdown.bottomAnchor, constant: 16),
            weightTextField.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 16),
            weightTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),

            // Breed TextField
            breedTextField.topAnchor.constraint(equalTo: weightTextField.bottomAnchor, constant: 16),
            breedTextField.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 16),
            breedTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),

            // Color TextField
            colorTextField.topAnchor.constraint(equalTo: breedTextField.bottomAnchor, constant: 16),
            colorTextField.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 16),
            colorTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),

            // Spayed/Neutered Label
            spayedLabel.topAnchor.constraint(equalTo: colorTextField.bottomAnchor, constant: 16),
            spayedLabel.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 16),

            // Spayed/Neutered Dropdown
            spayedDropdown.topAnchor.constraint(equalTo: spayedLabel.bottomAnchor, constant: 8),
            spayedDropdown.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 16),
            spayedDropdown.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            spayedDropdown.heightAnchor.constraint(equalToConstant: 40),

            // Additional Info TextField
            additionalInfoTextField.topAnchor.constraint(equalTo: spayedDropdown.bottomAnchor, constant: 16),
            additionalInfoTextField.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 16),
            additionalInfoTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),

            // Save Button
            saveButton.topAnchor.constraint(equalTo: additionalInfoTextField.bottomAnchor, constant: 24),
            saveButton.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 100),
            saveButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -100),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor, constant: -16)
        ])
    }
}
