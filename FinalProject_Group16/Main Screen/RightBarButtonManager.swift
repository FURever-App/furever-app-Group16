//
//  RightBarButtonManager.swift
//  FinalProject_Group16
//
//  Created by Zhiyu Li on 11/28/24.
//
import UIKit
import FirebaseAuth

extension ViewController{
    func setupRightBarButton(isLoggedIn: Bool) {
        if isLoggedIn {
            // User is logged in: Show "Log Out" button
            let logOutButton = UIBarButtonItem(
                title: "Logout",
                style: .plain,
                target: self,
                action: #selector(onLogOutBarButtonTapped)
            )
            navigationItem.rightBarButtonItem = logOutButton
        } else {
            // User is not logged in: Show "Sign In" and "Register" buttons
            let signInButton = UIBarButtonItem(
                title: "Login",
                style: .plain,
                target: self,
                action: #selector(onSignInBarButtonTapped)
            )
            
            let registerButton = UIBarButtonItem(
                title: "Register",
                style: .plain,
                target: self,
                action: #selector(onRegisterBarButtonTapped)
            )
            
            navigationItem.rightBarButtonItems = [registerButton, signInButton]
        }
    }

    @objc func onSignInBarButtonTapped() {
        let loginVC = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }

    @objc func onRegisterBarButtonTapped() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
  
    @objc func onLogOutBarButtonTapped(){
        let logoutAlert = UIAlertController(title: "Logging out!", message: "Are you sure want to log out?",
            preferredStyle: .actionSheet)
        logoutAlert.addAction(UIAlertAction(title: "Yes, log out!", style: .default, handler: {(_) in
                do{
                    try Auth.auth().signOut()
                }catch{
                    print("Error occured!")
                }
            })
        )
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(logoutAlert, animated: true)
    }
    
//    func signInToFirebase(email: String, password: String){
//        //MARK: can you display progress indicator here?
//        showActivityIndicator()
//        //MARK: authenticating the user...
//        Auth.auth().signIn(withEmail: email, password: password, completion: {(result, error) in
//            if error == nil{
//                //MARK: user authenticated...
//                //MARK: can you hide the progress indicator here?
//                self.hideActivityIndicator()
//            }else{
//                //MARK: alert that no user found or password wrong...
//            }
//        })
//    }
}
