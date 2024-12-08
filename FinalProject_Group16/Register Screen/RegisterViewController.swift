//
//  RegisterViewController.swift
//  FinalProject_Group16
//
//  Created by Zhiyu Li on 11/28/24.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import GoogleSignIn

class RegisterViewController: UIViewController {

    var registerView: RegisterView {
        return self.view as! RegisterView
    }
    
    let childProgressView = ProgressSpinnerViewController()
    let database = Firestore.firestore()


    override func loadView() {
        self.view = RegisterView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerView.registerButton.addTarget(self, action: #selector(onRegisterButtonTapped), for: .touchUpInside)
        registerView.googleButton.addTarget(self, action: #selector(signInWithGoogle), for: .touchUpInside)
        registerView.facebookButton.addTarget(self, action: #selector(signInWithFacebook), for: .touchUpInside)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)

    }
    
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen...
        view.endEditing(true)
    }
    
    @objc func onRegisterButtonTapped() {
        // Retrieve values from text fields
        guard var email = registerView.emailTextField.text, !email.isEmpty,
              let username = registerView.usernameTextField.text, !username.isEmpty,
              let password = registerView.passwordTextField.text, !password.isEmpty,
              let confirmPassword = registerView.confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            // Show an alert if any field is empty
            Utils.showAlert(on: self, title: "Error", message: "Please fill in all fields.")
            return
        }
        
        email = email.lowercased()
        // Check if email is valid
        guard isValidEmail(email) else {
            Utils.showAlert(on: self, title: "Error", message: "Please enter a valid email address.")
            return
        }
        
        // Check if passwords match
        guard password == confirmPassword else {
            Utils.showAlert(on: self, title: "Error", message: "Passwords do not match.")
            return
        }
        
        // Proceed to register the user
        registerUser(email: email, password: password, username: username)
    }
    
    // Helper function to validate email
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // Function to register the user
    private func registerUser(email: String, password: String, username: String) {
        showActivityIndicator()
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                // Show an error alert
                Utils.showAlert(on: self, title: "Registration Failed", message: error.localizedDescription)
                return
            }
            self.saveUserToFireStore(name: username, email: email)
            // Registration successful
            // Transition to main screen after successful registration
            // Ensure the user is authenticated before setting the display name
            self.setNameOfTheUserInFirebaseAuth(name: username) {
                self.hideActivityIndicator()
                Utils.transitionToMainScreen(from: self, mainVC: ViewController())
            }
        }
    }
    func saveUserToFireStore(name: String, email: String){
        database.collection("users")
             .document(email)
             .setData([
                 "name": name,
                 "email": email
             ]) { error in
                 if let error = error {
                     print("Error saving user to Firestore: \(error)")
                 } else {
                     print("User successfully saved to Firestore")
                 }
             }
    }
    // Set the name of the user after create the account...
    func setNameOfTheUserInFirebaseAuth(name: String, completion: @escaping () -> Void) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { error in
            if let error = error {
                print("Error occurred while setting display name: \(error.localizedDescription)")
            } else {
                print("Display name set successfully.")
                // Reload the user profile to reflect the updated display name
                Auth.auth().currentUser?.reload(completion: { reloadError in
                    if let reloadError = reloadError {
                        print("Error occurred while reloading user: \(reloadError.localizedDescription)")
                    } else {
                        print("User profile reloaded successfully.")
                        completion() // Notify that the update is complete
                    }
                })
            }
        }
    }
    
    @objc func signInWithGoogle() {
        Utils.signInWithGoogle(from: self) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let user):
                print("User signed in: \(user.email ?? "No email")")
                Utils.transitionToMainScreen(from: self, mainVC: ViewController())
            case .failure(let error):
                Utils.showAlert(on: self, title: "Sign-In Failed", message: error.localizedDescription)
            }
        }
    }
    
    @objc func signInWithFacebook() {
        Utils.signInWithFB(from: self)
    }
}
