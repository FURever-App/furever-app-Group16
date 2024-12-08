//
//  EditViewController.swift
//  FinalProject_Group16
//
//  Created by Zhiyu Li on 11/28/24.
//
//


import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let editPetView = EditView()
    var pet: Pet?
    var delegateToDisplay: DisplayViewController!
    
    let childProgressView = ProgressSpinnerViewController()

    override func loadView() {
        self.view = editPetView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("EditViewController loaded")
        setupInitialData()
        editPetView.editPhotoButton.addTarget(self, action: #selector(editPhotoTapped), for: .touchUpInside)
        editPetView.saveButton.addTarget(self, action: #selector(onSaveButtonTapped), for: .touchUpInside)
        
        //MARK: recognizing the taps on the app screen, not the keyboard...
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }
    
    //MARK: Hide Keyboard...
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen...
        view.endEditing(true)
    }

    func setupInitialData() {
        guard let pet = pet else {
            print("Pet object is nil")
            return
        }
        print("Setting up initial data for pet: \(pet)")

        editPetView.nameTextField.text = pet.name
        editPetView.ageTextField.text = "\(pet.age)"
        editPetView.weightTextField.text = "\(pet.weight)"
        editPetView.breedTextField.text = pet.breed
        editPetView.colorTextField.text = pet.color
        editPetView.sexDropdown.setTitle(pet.sex.rawValue, for: .normal)
        editPetView.spayedDropdown.setTitle(pet.isSpayedOrNeutered ? "Yes" : "No", for: .normal)
        editPetView.additionalInfoTextField.text = pet.additionalInfo
        
        if pet.type == .dog {
            editPetView.dogButton.backgroundColor = UIColor(red: 207/255.0, green: 178/255.0, blue: 159/255.0, alpha: 1)
            editPetView.catButton.backgroundColor = .lightGray
        } else if pet.type == .cat {
            editPetView.catButton.backgroundColor = UIColor(red: 207/255.0, green: 178/255.0, blue: 159/255.0, alpha: 1)
            editPetView.dogButton.backgroundColor = .lightGray
        }

        if let photoURL = URL(string: pet.photoURL) {
            print("Loading pet image from URL: \(photoURL)")
            loadImage(from: photoURL)
        } else {
            print("Pet photo URL is invalid or nil")
        }
    }

    @objc func onSaveButtonTapped() {
        showActivityIndicator()
        guard let pet = pet,
              let name = editPetView.nameTextField.text, !name.isEmpty,
              let ageText = editPetView.ageTextField.text, let age = Int(ageText),
              let weightText = editPetView.weightTextField.text, let weight = Int(weightText),
              let breed = editPetView.breedTextField.text, !breed.isEmpty,
              let color = editPetView.colorTextField.text, !color.isEmpty else {
            print("Validation failed. One or more fields are empty.")
            Utils.showAlert(on: self, title: "Error", message: "Please fill in all fields.")
            return
        }

        let sex = PetSex(rawValue: editPetView.sexDropdown.title(for: .normal) ?? "Male") ?? .male
        let isSpayed = editPetView.spayedDropdown.title(for: .normal) == "Yes"
        let additionalInfo = editPetView.additionalInfoTextField.text ?? ""

        if let newImage = editPetView.petImageView.image, newImage != UIImage(systemName: "photo") {
            print("New image detected. Starting upload.")
            uploadImageToFirebase(image: newImage) { [weak self] imageURL in
                guard let self = self, let imageURL = imageURL else {
                    print("Failed to upload new image")
                    Utils.showAlert(on: self!, title: "Error", message: "Failed to upload image.")
                    return
                }
                print("New image uploaded successfully: \(imageURL)")
                
                // Delete the old image from Firebase Storage
                Utils.deleteOldImageFromStorage(oldImageURL: pet.photoURL)
                
                let updatedPet = Pet(
                    id: pet.id,
                    photoURL: imageURL,
                    type: pet.type,
                    name: name,
                    age: age,
                    sex: sex,
                    weight: weight,
                    breed: breed,
                    color: color,
                    isSpayedOrNeutered: isSpayed,
                    additionalInfo: additionalInfo
                )
                self.saveUpdatedPetToFirestore(updatedPet)
            }
        } else {
            print("No new image detected. Using existing photo URL.")
            let updatedPet = Pet(
                id: pet.id,
                photoURL: pet.photoURL,
                type: pet.type,
                name: name,
                age: age,
                sex: sex,
                weight: weight,
                breed: breed,
                color: color,
                isSpayedOrNeutered: isSpayed,
                additionalInfo: additionalInfo
            )
            saveUpdatedPetToFirestore(updatedPet)
        }
    }
    
    func saveUpdatedPetToFirestore(_ updatedPet: Pet) {
        guard let userEmail = Auth.auth().currentUser?.email, let petID = updatedPet.id else {
            print("User email or pet ID is nil. Cannot update Firestore.")
            return
        }
        
        print("Saving updated pet to Firestore: \(updatedPet)")
        let petDoc = Firestore.firestore()
            .collection("users")
            .document(userEmail)
            .collection("pets")
            .document(petID)

        do {
            try petDoc.setData(from: updatedPet) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    print("Firestore update failed: \(error.localizedDescription)")
                    Utils.showAlert(on: self, title: "Error", message: "Failed to save pet: \(error.localizedDescription)")
                } else {
                    print("Firestore update successful")
                    self.hideActivityIndicator()
                    self.delegateToDisplay.reload(pet: updatedPet)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } catch {
            print("Failed to encode pet data: \(error.localizedDescription)")
            hideActivityIndicator()
            Utils.showAlert(on: self, title: "Error", message: "Failed to encode pet data.")
        }
    }
    
    func loadImage(from url: URL) {
        print("Attempting to load image from URL: \(url)")
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print("Failed to load pet image: \(error.localizedDescription)")
                return
            }
            guard let self = self, let data = data else {
                print("Failed to load pet image. Data is nil.")
                return
            }
            DispatchQueue.main.async {
                print("Pet image loaded successfully")
                self.editPetView.petImageView.image = UIImage(data: data)
                self.editPetView.bringSubviewToFront(self.editPetView.editPhotoButton)
            }
        }
        task.resume()
    }

    @objc func editPhotoTapped() {
        print("Edit photo button tapped")
        let alert = UIAlertController(title: "Upload Photo", message: "Choose a source", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            print("Camera selected")
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            print("Gallery selected")
            self.openGallery()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func openCamera() {
        print("Opening camera")
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        } else {
            print("Camera not available")
        }
    }

    func openGallery() {
        print("Opening gallery")
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        } else {
            print("Photo library not available")
        }
    }

    // Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            print("Image picked successfully")
            editPetView.petImageView.image = image
        } else {
            print("Failed to pick image")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Image picker cancelled")
        picker.dismiss(animated: true, completion: nil)
    }

    func uploadImageToFirebase(image: UIImage, completion: @escaping (String?) -> Void) {
        print("Starting image upload")
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to compress image")
            completion(nil)
            return
        }

        let storageRef = Storage.storage().reference()
            .child("pet_images/\(UUID().uuidString).jpg")

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Image upload failed: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Failed to retrieve download URL: \(error.localizedDescription)")
                    completion(nil)
                } else {
                    print("Image uploaded successfully. URL: \(url?.absoluteString ?? "nil")")
                    completion(url?.absoluteString)
                }
            }
        }
    }
}

//import UIKit
//import FirebaseFirestore
//import FirebaseAuth
//import FirebaseStorage
//
//class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    
//    let editPetView = EditView()
//    var pet: Pet?
//    var delegateToDisplay: DisplayViewController!
//    var currentUser: FirebaseAuth.User?
//    let childProgressView = ProgressSpinnerViewController()
//
//    override func loadView() {
//        self.view = editPetView
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("EditViewController loaded")
//        setupInitialData()
//        editPetView.editPhotoButton.addTarget(self, action: #selector(editPhotoTapped), for: .touchUpInside)
//        editPetView.saveButton.addTarget(self, action: #selector(onSaveButtonTapped), for: .touchUpInside)
//        
//        //MARK: recognizing the taps on the app screen, not the keyboard...
//        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
//        tapRecognizer.cancelsTouchesInView = false
//        view.addGestureRecognizer(tapRecognizer)
//    }
//    
//    //MARK: Hide Keyboard...
//    @objc func hideKeyboardOnTap(){
//        //MARK: removing the keyboard from screen...
//        view.endEditing(true)
//    }
//
//    func setupInitialData() {
//        guard let pet = pet else {
//            print("Pet object is nil")
//            return
//        }
//        print("Setting up initial data for pet: \(pet)")
//
//        editPetView.nameTextField.text = pet.name
//        editPetView.ageTextField.text = "\(pet.age)"
//        editPetView.weightTextField.text = "\(pet.weight)"
//        editPetView.breedTextField.text = pet.breed
//        editPetView.colorTextField.text = pet.color
//        editPetView.sexDropdown.setTitle(pet.sex.rawValue, for: .normal)
//        editPetView.spayedDropdown.setTitle(pet.isSpayedOrNeutered ? "Yes" : "No", for: .normal)
//        editPetView.additionalInfoTextField.text = pet.additionalInfo
//        
//        if pet.type == .dog {
//            editPetView.dogButton.backgroundColor = UIColor(red: 207/255.0, green: 178/255.0, blue: 159/255.0, alpha: 1)
//            editPetView.catButton.backgroundColor = .lightGray
//        } else if pet.type == .cat {
//            editPetView.catButton.backgroundColor = UIColor(red: 207/255.0, green: 178/255.0, blue: 159/255.0, alpha: 1)
//            editPetView.dogButton.backgroundColor = .lightGray
//        }
//
//        if let photoURL = URL(string: pet.photoURL) {
//            print("Loading pet image from URL: \(photoURL)")
//            loadImage(from: photoURL)
//        } else {
//            print("Pet photo URL is invalid or nil")
//        }
//    }
//
//    @objc func onSaveButtonTapped() {
//        showActivityIndicator()
//        guard let pet = pet,
//              let name = editPetView.nameTextField.text, !name.isEmpty,
//              let ageText = editPetView.ageTextField.text, let age = Int(ageText),
//              let weightText = editPetView.weightTextField.text, let weight = Int(weightText),
//              let breed = editPetView.breedTextField.text, !breed.isEmpty,
//              let color = editPetView.colorTextField.text, !color.isEmpty else {
//            print("Validation failed. One or more fields are empty.")
//            Utils.showAlert(on: self, title: "Error", message: "Please fill in all fields.")
//            return
//        }
//
//        let sex = PetSex(rawValue: editPetView.sexDropdown.title(for: .normal) ?? "Male") ?? .male
//        let isSpayed = editPetView.spayedDropdown.title(for: .normal) == "Yes"
//        let additionalInfo = editPetView.additionalInfoTextField.text ?? ""
//
//        if let newImage = editPetView.petImageView.image, newImage != UIImage(systemName: "photo") {
//            print("New image detected. Starting upload.")
//            uploadImageToFirebase(image: newImage) { [weak self] imageURL in
//                guard let self = self, let imageURL = imageURL else {
//                    print("Failed to upload new image")
//                    Utils.showAlert(on: self!, title: "Error", message: "Failed to upload image.")
//                    return
//                }
//                print("New image uploaded successfully: \(imageURL)")
//                
//                // Delete the old image from Firebase Storage
//                Utils.deleteOldImageFromStorage(oldImageURL: pet.photoURL)
//                
//                let updatedPet = Pet(
//                    id: pet.id,
//                    ownerEmail: (self.currentUser?.email)!,
//                    photoURL: imageURL,
//                    type: pet.type,
//                    name: name,
//                    age: age,
//                    sex: sex,
//                    weight: weight,
//                    breed: breed,
//                    color: color,
//                    isSpayedOrNeutered: isSpayed,
//                    additionalInfo: additionalInfo
//                )
//                self.saveUpdatedPetToFirestore(updatedPet)
//            }
//        } else {
//            print("No new image detected. Using existing photo URL.")
//            let updatedPet = Pet(
//                id: pet.id,
//                ownerEmail: (self.currentUser?.email)!,
//                photoURL: pet.photoURL,
//                type: pet.type,
//                name: name,
//                age: age,
//                sex: sex,
//                weight: weight,
//                breed: breed,
//                color: color,
//                isSpayedOrNeutered: isSpayed,
//                additionalInfo: additionalInfo
//            )
//            saveUpdatedPetToFirestore(updatedPet)
//        }
//    }
//    
//    func saveUpdatedPetToFirestore(_ updatedPet: Pet) {
//        guard let userEmail = Auth.auth().currentUser?.email, let petID = updatedPet.id else {
//            print("User email or pet ID is nil. Cannot update Firestore.")
//            return
//        }
//        
//        print("Saving updated pet to Firestore: \(updatedPet)")
//        let petDoc = Firestore.firestore()
//            .collection("users")
//            .document(userEmail)
//            .collection("pets")
//            .document(petID)
//
//        do {
//            try petDoc.setData(from: updatedPet) { [weak self] error in
//                guard let self = self else { return }
//                if let error = error {
//                    print("Firestore update failed: \(error.localizedDescription)")
//                    Utils.showAlert(on: self, title: "Error", message: "Failed to save pet: \(error.localizedDescription)")
//                } else {
//                    print("Firestore update successful")
//                    self.hideActivityIndicator()
//                    self.delegateToDisplay.reload(pet: updatedPet)
//                    self.navigationController?.popViewController(animated: true)
//                }
//            }
//        } catch {
//            print("Failed to encode pet data: \(error.localizedDescription)")
//            hideActivityIndicator()
//            Utils.showAlert(on: self, title: "Error", message: "Failed to encode pet data.")
//        }
//    }
//    
//    func loadImage(from url: URL) {
//        print("Attempting to load image from URL: \(url)")
//        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
//            if let error = error {
//                print("Failed to load pet image: \(error.localizedDescription)")
//                return
//            }
//            guard let self = self, let data = data else {
//                print("Failed to load pet image. Data is nil.")
//                return
//            }
//            DispatchQueue.main.async {
//                print("Pet image loaded successfully")
//                self.editPetView.petImageView.image = UIImage(data: data)
//                self.editPetView.bringSubviewToFront(self.editPetView.editPhotoButton)
//            }
//        }
//        task.resume()
//    }
//
//    @objc func editPhotoTapped() {
//        print("Edit photo button tapped")
//        let alert = UIAlertController(title: "Upload Photo", message: "Choose a source", preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
//            print("Camera selected")
//            self.openCamera()
//        }))
//        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
//            print("Gallery selected")
//            self.openGallery()
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    func openCamera() {
//        print("Opening camera")
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            let picker = UIImagePickerController()
//            picker.delegate = self
//            picker.sourceType = .camera
//            self.present(picker, animated: true, completion: nil)
//        } else {
//            print("Camera not available")
//        }
//    }
//
//    func openGallery() {
//        print("Opening gallery")
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//            let picker = UIImagePickerController()
//            picker.delegate = self
//            picker.sourceType = .photoLibrary
//            self.present(picker, animated: true, completion: nil)
//        } else {
//            print("Photo library not available")
//        }
//    }
//
//    // Image Picker Delegate
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[.originalImage] as? UIImage {
//            print("Image picked successfully")
//            editPetView.petImageView.image = image
//        } else {
//            print("Failed to pick image")
//        }
//        picker.dismiss(animated: true, completion: nil)
//    }
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        print("Image picker cancelled")
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//    func uploadImageToFirebase(image: UIImage, completion: @escaping (String?) -> Void) {
//        print("Starting image upload")
//        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
//            print("Failed to compress image")
//            completion(nil)
//            return
//        }
//
//        let storageRef = Storage.storage().reference()
//            .child("pet_images/\(UUID().uuidString).jpg")
//
//        storageRef.putData(imageData, metadata: nil) { metadata, error in
//            if let error = error {
//                print("Image upload failed: \(error.localizedDescription)")
//                completion(nil)
//                return
//            }
//            
//            storageRef.downloadURL { url, error in
//                if let error = error {
//                    print("Failed to retrieve download URL: \(error.localizedDescription)")
//                    completion(nil)
//                } else {
//                    print("Image uploaded successfully. URL: \(url?.absoluteString ?? "nil")")
//                    completion(url?.absoluteString)
//                }
//            }
//        }
//    }
//}
