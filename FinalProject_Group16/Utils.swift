//
//  Utils.swift
//  FinalProject_Group16
//
//  Created by Zhiyu Li on 11/28/24.
//

import UIKit
import Foundation
import FirebaseStorage
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import FacebookLogin

class Utils {
    // MARK: - Transition to Main Screen
    static func transitionToMainScreen(from viewController: UIViewController, mainVC: UIViewController) {
        // Ensure we are using the current window scene
        guard let windowScene = viewController.view.window?.windowScene else {
            print("Error: No active window scene found.")
            return
        }

        // Find the key window in the window scene
        guard let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            print("Error: No key window found.")
            return
        }

        // Create a navigation controller with the main screen
        let navController = UINavigationController(rootViewController: mainVC)

        // Set the new rootViewController with a smooth transition
        window.rootViewController = navController
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    // MARK: - Show Alert
    static func showAlert(on viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Delete Old Image
    static func deleteOldImageFromStorage(oldImageURL: String) {
        let storage = Storage.storage()
        
        // Extract the file path from the URL
        if let url = URL(string: oldImageURL),
           let _ = url.query,
           let filePathEncoded = url.path.split(separator: "/").last?.removingPercentEncoding {
            
            let filePath = "pet_images/\(filePathEncoded)" // Construct the full file path
            let oldImageRef = storage.reference(withPath: filePath)

            // Attempt to delete the file
            oldImageRef.delete { error in
                if let error = error {
                    print("Failed to delete old image: \(error.localizedDescription)")
                } else {
                    print("Old image deleted successfully.")
                }
            }
        } else {
            print("Invalid old image URL: \(oldImageURL)")
        }
    }
    
    // MARK: - Sign in with Google
    static func signInWithGoogle(from viewController: UIViewController, completion: @escaping (Result<FirebaseAuth.User, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(NSError(domain: "GoogleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "No client ID found in Firebase configuration."])))
            return
        }

        _ = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { signInResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let idToken = signInResult?.user.idToken?.tokenString else {
                completion(.failure(NSError(domain: "GoogleSignIn", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve ID token."])))
                return
            }

            guard let accessToken = signInResult?.user.accessToken.tokenString else {
                completion(.failure(NSError(domain: "GoogleSignIn", code: -3, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve access token."])))
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                } else if let user = authResult?.user {
                    completion(.success(user))
                }
            }
        }
    }
    
    // MARK: - Sign in with Facebook
    static func signInWithFB(from viewController: UIViewController) {
        let loginManager = LoginManager()
        
        // Request permissions from Facebook
        loginManager.logIn(permissions: ["public_profile", "email"], from: viewController) { result, error in
            if let error = error {
                print("Facebook login failed: \(error.localizedDescription)")
                return
            }
            
            guard let result = result, !result.isCancelled else {
                print("Facebook login was cancelled.")
                return
            }
            
            print("Facebook login successful. Token: \(result.token?.tokenString ?? "No token")")
            
            // Retrieve the Facebook Access Token
            guard let accessToken = AccessToken.current?.tokenString else {
                print("Failed to retrieve Facebook access token.")
                return
            }
            
            // Use Firebase to authenticate with the Facebook credential
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase authentication failed: \(error.localizedDescription)")
                    return
                }
                
                // Successfully signed in
                print("User signed in with Firebase. Email: \(authResult?.user.email ?? "No email")")
                
                // Transition to the main screen
                Utils.transitionToMainScreen(from: viewController, mainVC: ViewController())
            }
        }
    }


}
