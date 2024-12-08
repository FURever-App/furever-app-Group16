//
//  AddPetViewController.swift
//  FinalProject_Group16
//
//  Created by Zhiyu Li on 11/28/24.
//
//


import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class AddPetViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let addPetView = AddPetView()
    var selectedPetImage: UIImage?
    var selectedPetType: PetType?

    let childProgressView = ProgressSpinnerViewController()

    override func loadView() {
        self.view = addPetView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addPetView.uploadPhotoButton.addTarget(self, action: #selector(uploadPhotoTapped), for: .touchUpInside)
        addPetView.dogButton.addTarget(self, action: #selector(selectDog), for: .touchUpInside)
        addPetView.catButton.addTarget(self, action: #selector(selectCat), for: .touchUpInside)
        addPetView.saveButton.addTarget(self, action: #selector(onSaveButtonTapped), for: .touchUpInside)
        
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
    
    @objc func uploadPhotoTapped() {
        let alert = UIAlertController(title: "Upload Photo", message: "Choose a source", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    // Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedPetImage = image
            addPetView.uploadPhotoButton.setBackgroundImage(image, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // change color when selected
    @objc func selectDog() {
        selectedPetType = .dog
        addPetView.dogButton.backgroundColor = UIColor(red: 207/255.0, green: 178/255.0, blue: 159/255.0, alpha: 1)
        addPetView.catButton.backgroundColor = .lightGray
    }

    @objc func selectCat() {
        selectedPetType = .cat
        addPetView.catButton.backgroundColor = UIColor(red: 207/255.0, green: 178/255.0, blue: 159/255.0, alpha: 1)
        addPetView.dogButton.backgroundColor = .lightGray
    }
    
    @objc func onSaveButtonTapped() {
        // Validate inputs
        guard let image = selectedPetImage else {
            Utils.showAlert(on: self, title: "Error", message: "Please upload a photo of your pet.")
            return
        }
        
        guard let name = addPetView.nameTextField.text, !name.isEmpty,
              let ageText = addPetView.ageTextField.text, let age = Int(ageText),
              let weightText = addPetView.weightTextField.text, let weight = Int(weightText),
              let breed = addPetView.breedTextField.text, !breed.isEmpty,
              let color = addPetView.colorTextField.text, !color.isEmpty,
              let sexText = addPetView.sexDropdown.title(for: .normal), let sex = PetSex(rawValue: sexText),
              let spayedText = addPetView.spayedDropdown.title(for: .normal) else {
            Utils.showAlert(on: self, title: "Missing Information", message: "Please fill in all required fields.")
            return
        }
        
        guard let type = selectedPetType else {
            Utils.showAlert(on: self, title: "Missing Information", message: "Please select a pet type (Dog or Cat).")
            return
        }
        
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
               Utils.showAlert(on: self, title: "Error", message: "No authenticated user found.")
               return
           }
        
        let isSpayedOrNeutered = spayedText == "Yes"
        let additionalInfo = addPetView.additionalInfoTextField.text
        
        // Upload the image to Firebase Storage
        uploadImageToFirebase(image: image) { [weak self] imageURL in
            guard let self = self, let imageURL = imageURL else {
                Utils.showAlert(on: self!, title: "Error", message: "Failed to upload the image. Please try again.")
                return
            }
            
            // Create the Pet object
            let pet = Pet(
                photoURL: imageURL.absoluteString,
                type: type,
                name: name,
                age: age,
                sex: sex,
                weight: weight,
                breed: breed,
                color: color,
                isSpayedOrNeutered: isSpayedOrNeutered,
                additionalInfo: additionalInfo,
                ownerEmail: currentUserEmail
            )
            
            // Save the pet to Firestore
            self.savePetToFirestore(pet: pet)
        }
    }

    func uploadImageToFirebase(image: UIImage, completion: @escaping (URL?) -> Void) {
        showActivityIndicator()
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }
        
        let storageRef = Storage.storage().reference()
        let uniqueImageName = UUID().uuidString // Generate a unique name for the image
        let imageRef = storageRef.child("pet_images/\(uniqueImageName).jpg") // Path in Firebase Storage
        
        // Upload the image
        imageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Retrieve the download URL
            imageRef.downloadURL { url, error in
                if let error = error {
                    print("Error fetching download URL: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                completion(url)
            }
        }
    }
    

    func savePetToFirestore(pet: Pet) {
        guard let currentUser = Auth.auth().currentUser, let userEmail = currentUser.email else {
            Utils.showAlert(on: self, title: "Error", message: "No authenticated user found.")
            return
        }
        
        // Reference the pets subcollection under the current user's document
        let collectionPets = Firestore.firestore()
            .collection("users")
            .document(userEmail)
            .collection("pets")
                
        do {
            // Encode the Pet object into Firestore
            try collectionPets.addDocument(from: pet, completion: { [weak self] error in
                guard let self = self else { return }
                self.hideActivityIndicator() // Hide loading indicator
                
                if let error = error {
                    // Show an error message if saving failed
                    Utils.showAlert(on: self, title: "Error", message: "Failed to save pet: \(error.localizedDescription)")
                } else {
                    // Successfully saved, navigate back to the main screen
                    self.navigationController?.popViewController(animated: true)
                }
            })
        } catch {
            hideActivityIndicator()
            Utils.showAlert(on: self, title: "Error", message: "Failed to encode pet data.")
        }
    }
}




//import UIKit
//import FirebaseAuth
//import FirebaseFirestore
//import FirebaseStorage
//
//class AddPetViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    var handleAuth: AuthStateDidChangeListenerHandle?
//    let addPetView = AddPetView()
//    var selectedPetImage: UIImage?
//    var selectedPetType: PetType?
//    var currentUser:FirebaseAuth.User?
//
//    let childProgressView = ProgressSpinnerViewController()
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        //MARK: handling if the Authentication state is changed (sign in, sign out, register)...
//        handleAuth = Auth.auth().addStateDidChangeListener{ auth, user in
//            if user == nil{
//                //MARK: the user is not signed in...
//                self.currentUser = nil
//            }else{
//                //MARK: the user is signed in...
//                self.currentUser = user
//            }
//        }
//    }
//
//    override func loadView() {
//        self.view = addPetView
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        addPetView.uploadPhotoButton.addTarget(self, action: #selector(uploadPhotoTapped), for: .touchUpInside)
//        addPetView.dogButton.addTarget(self, action: #selector(selectDog), for: .touchUpInside)
//        addPetView.catButton.addTarget(self, action: #selector(selectCat), for: .touchUpInside)
//        addPetView.saveButton.addTarget(self, action: #selector(onSaveButtonTapped), for: .touchUpInside)
//        
//        //MARK: recognizing the taps on the app screen, not the keyboard...
//        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
//        tapRecognizer.cancelsTouchesInView = false
//        view.addGestureRecognizer(tapRecognizer)
//
//    }
//    
//    //MARK: Hide Keyboard...
//    @objc func hideKeyboardOnTap(){
//        //MARK: removing the keyboard from screen...
//        view.endEditing(true)
//    }
//    
//    @objc func uploadPhotoTapped() {
//        let alert = UIAlertController(title: "Upload Photo", message: "Choose a source", preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
//            self.openCamera()
//        }))
//        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
//            self.openGallery()
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
//    
//    func openCamera() {
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            let picker = UIImagePickerController()
//            picker.delegate = self
//            picker.sourceType = .camera
//            self.present(picker, animated: true, completion: nil)
//        }
//    }
//    
//    func openGallery() {
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//            let picker = UIImagePickerController()
//            picker.delegate = self
//            picker.sourceType = .photoLibrary
//            self.present(picker, animated: true, completion: nil)
//        }
//    }
//    
//    // Image Picker Delegate
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[.originalImage] as? UIImage {
//            selectedPetImage = image
//            addPetView.uploadPhotoButton.setBackgroundImage(image, for: .normal)
//        }
//        picker.dismiss(animated: true, completion: nil)
//    }
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//    
//    // change color when selected
//    @objc func selectDog() {
//        selectedPetType = .dog
//        addPetView.dogButton.backgroundColor = UIColor(red: 207/255.0, green: 178/255.0, blue: 159/255.0, alpha: 1)
//        addPetView.catButton.backgroundColor = .lightGray
//    }
//
//    @objc func selectCat() {
//        selectedPetType = .cat
//        addPetView.catButton.backgroundColor = UIColor(red: 207/255.0, green: 178/255.0, blue: 159/255.0, alpha: 1)
//        addPetView.dogButton.backgroundColor = .lightGray
//    }
//    
//    @objc func onSaveButtonTapped() {
//        // Validate inputs
//        guard let image = selectedPetImage else {
//            Utils.showAlert(on: self, title: "Error", message: "Please upload a photo of your pet.")
//            return
//        }
//        
//        guard let name = addPetView.nameTextField.text, !name.isEmpty,
//              let ageText = addPetView.ageTextField.text, let age = Int(ageText),
//              let weightText = addPetView.weightTextField.text, let weight = Int(weightText),
//              let breed = addPetView.breedTextField.text, !breed.isEmpty,
//              let color = addPetView.colorTextField.text, !color.isEmpty,
//              let sexText = addPetView.sexDropdown.title(for: .normal), let sex = PetSex(rawValue: sexText),
//              let spayedText = addPetView.spayedDropdown.title(for: .normal) else {
//            Utils.showAlert(on: self, title: "Missing Information", message: "Please fill in all required fields.")
//            return
//        }
//        
//        guard let type = selectedPetType else {
//            Utils.showAlert(on: self, title: "Missing Information", message: "Please select a pet type (Dog or Cat).")
//            return
//        }
//
//        let isSpayedOrNeutered = spayedText == "Yes"
//        let additionalInfo = addPetView.additionalInfoTextField.text
//        
//        // Upload the image to Firebase Storage
//        uploadImageToFirebase(image: image) { [weak self] imageURL in
//            guard let self = self, let imageURL = imageURL else {
//                Utils.showAlert(on: self!, title: "Error", message: "Failed to upload the image. Please try again.")
//                return
//            }
//            
//            // Create the Pet object
//            let pet = Pet(
//                ownerEmail: (self.currentUser?.email)!,
//                photoURL: imageURL.absoluteString,
//                type: type,
//                name: name,
//                age: age,
//                sex: sex,
//                weight: weight,	
//                breed: breed,
//                color: color,
//                isSpayedOrNeutered: isSpayedOrNeutered,
//                additionalInfo: additionalInfo
//            )
//            
//            // Save the pet to Firestore
//            self.savePetToFirestore(pet: pet)
//        }
//    }
//
//    func uploadImageToFirebase(image: UIImage, completion: @escaping (URL?) -> Void) {
//        showActivityIndicator() 
//        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
//            completion(nil)
//            return
//        }
//        
//        let storageRef = Storage.storage().reference()
//        let uniqueImageName = UUID().uuidString // Generate a unique name for the image
//        let imageRef = storageRef.child("pet_images/\(uniqueImageName).jpg") // Path in Firebase Storage
//        
//        // Upload the image
//        imageRef.putData(imageData, metadata: nil) { _, error in
//            if let error = error {
//                print("Error uploading image: \(error.localizedDescription)")
//                completion(nil)
//                return
//            }
//            
//            // Retrieve the download URL
//            imageRef.downloadURL { url, error in
//                if let error = error {
//                    print("Error fetching download URL: \(error.localizedDescription)")
//                    completion(nil)
//                    return
//                }
//                completion(url)
//            }
//        }
//    }
//    
//
//    func savePetToFirestore(pet: Pet) {
//        guard let currentUser = Auth.auth().currentUser, let userEmail = currentUser.email else {
//            Utils.showAlert(on: self, title: "Error", message: "No authenticated user found.")
//            return
//        }
//        
//        // Reference the pets subcollection under the current user's document
//        let collectionPets = Firestore.firestore()
//            .collection("users")
//            .document(userEmail)
//            .collection("pets")
//                
//        do {
//            // Encode the Pet object into Firestore
//            try collectionPets.addDocument(from: pet, completion: { [weak self] error in
//                guard let self = self else { return }
//                self.hideActivityIndicator() // Hide loading indicator
//                
//                if let error = error {
//                    // Show an error message if saving failed
//                    Utils.showAlert(on: self, title: "Error", message: "Failed to save pet: \(error.localizedDescription)")
//                } else {
//                    // Successfully saved, navigate back to the main screen
//                    self.navigationController?.popViewController(animated: true)
//                }
//            })
//        } catch {
//            hideActivityIndicator()
//            Utils.showAlert(on: self, title: "Error", message: "Failed to encode pet data.")
//        }
//    }
//}
//
