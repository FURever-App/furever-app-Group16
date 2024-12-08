//
//  LoginViewController.swift
//  FinalProject_Group16
//
//  Created by Zhiyu Li on 11/28/24.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    var loginView: LoginView {
        return self.view as! LoginView
    }
    
    let childProgressView = ProgressSpinnerViewController()

    override func loadView() {
        self.view = LoginView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginView.loginButton.addTarget(self, action: #selector(onLoginButtonTapped), for: .touchUpInside)
        loginView.googleButton.addTarget(self, action: #selector(signInWithGoogle), for: .touchUpInside)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen...
        view.endEditing(true)
    }
    
    @objc func onLoginButtonTapped() {
        // Retrieve email and password from text fields
        guard var email = loginView.emailTextField.text, !email.isEmpty,
              let password = loginView.passwordTextField.text, !password.isEmpty else {
            // Show an alert if email or password is empty
            Utils.showAlert(on: self, title: "Error", message: "Please enter both email and password.")
            return
        }
        email = email.lowercased()
        // Attempt to sign in to Firebase
        signInToFirebase(email: email, password: password)
    }
    
    func signInToFirebase(email: String, password: String) {
        showActivityIndicator()
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                // Show an error alert using Utils
                Utils.showAlert(on: self, title: "Login Failed", message: error.localizedDescription)
                return
            }
            
            // Login successful
            // Transition to the main screen
            hideActivityIndicator()
            Utils.transitionToMainScreen(from: self, mainVC: ViewController())
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
}
