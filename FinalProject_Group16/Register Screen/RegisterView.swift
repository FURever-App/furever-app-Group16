//
//  RegisterView.swift
//  FinalProject_Group16
//
//  Created by Zhiyu Li on 11/28/24.
//

import UIKit

class RegisterView: UIView {
    
    var titleLabel: UILabel!
    var emailTextField: UITextField!
    var usernameTextField: UITextField!
    var passwordTextField: UITextField!
    var confirmPasswordTextField: UITextField!
    var registerButton: UIButton!
    var greyLine: UIView!
    var orRegisterLabel: UILabel!
    var facebookButton: UIButton!
    var googleButton: UIButton!
    var appleButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupTitleLabel()
        setupEmailTextField()
        setupUsernameTextField()
        setupPasswordTextField()
        setupConfirmPasswordTextField()
        setupRegisterButton()
        setupGreyLine()
        setupOrRegisterLabel()
        setupFacebookButton()
        setupGoogleButton()
        setupAppleButton()
        initConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI Elements
    func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "Register to FURever"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
    }
    
    func setupEmailTextField() {
        emailTextField = UITextField()
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(emailTextField)
    }
    
    func setupUsernameTextField() {
        usernameTextField = UITextField()
        usernameTextField.placeholder = "Username"
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(usernameTextField)
    }
    
    func setupPasswordTextField() {
        passwordTextField = UITextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(passwordTextField)
    }
    
    func setupConfirmPasswordTextField() {
        confirmPasswordTextField = UITextField()
        confirmPasswordTextField.placeholder = "Confirm Password"
        confirmPasswordTextField.borderStyle = .roundedRect
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(confirmPasswordTextField)
    }
    
    func setupRegisterButton() {
        registerButton = UIButton(type: .system)
        registerButton.setTitle("Register", for: .normal)
        registerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        registerButton.backgroundColor = .systemBlue
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.cornerRadius = 8
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(registerButton)
    }
    
    func setupGreyLine() {
        greyLine = UIView()
        greyLine.backgroundColor = .lightGray
        greyLine.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(greyLine)
    }
    
    func setupOrRegisterLabel() {
        orRegisterLabel = UILabel()
        orRegisterLabel.text = "Or register with..."
        orRegisterLabel.font = UIFont.systemFont(ofSize: 14)
        orRegisterLabel.textAlignment = .center
        orRegisterLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(orRegisterLabel)
    }
    
    func setupFacebookButton() {
        facebookButton = UIButton(type: .system)
        facebookButton.setImage(UIImage(named: "facebook")?.withRenderingMode(.alwaysOriginal), for: .normal)
        facebookButton.imageView?.contentMode = .scaleAspectFit
        facebookButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(facebookButton)
    }
    
    func setupGoogleButton() {
        googleButton = UIButton(type: .system)
        googleButton.setImage(UIImage(named: "google")?.withRenderingMode(.alwaysOriginal), for: .normal)
        googleButton.imageView?.contentMode = .scaleAspectFit
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(googleButton)
    }
    
    func setupAppleButton() {
        appleButton = UIButton(type: .system)
        appleButton.setImage(UIImage(named: "apple")?.withRenderingMode(.alwaysOriginal), for: .normal)
        appleButton.imageView?.contentMode = .scaleAspectFit
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(appleButton)
    }
    
    // MARK: - Setup Constraints
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            // Email TextField
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            emailTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            
            // Username TextField
            usernameTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            usernameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            usernameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            
            // Password TextField
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            passwordTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            
            // Confirm Password TextField
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            
            // Register Button
            registerButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 24),
            registerButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            registerButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            registerButton.heightAnchor.constraint(equalToConstant: 48),
            
            // Grey Line
            greyLine.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 24),
            greyLine.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            greyLine.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            greyLine.heightAnchor.constraint(equalToConstant: 1),
            
            // Or Register Label
            orRegisterLabel.topAnchor.constraint(equalTo: greyLine.bottomAnchor, constant: 16),
            orRegisterLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            // Facebook Button
            facebookButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 48),
            facebookButton.trailingAnchor.constraint(equalTo: googleButton.leadingAnchor, constant: -16),
            facebookButton.topAnchor.constraint(equalTo: orRegisterLabel.bottomAnchor, constant: 32),
            facebookButton.heightAnchor.constraint(equalToConstant: 24),
            facebookButton.widthAnchor.constraint(equalToConstant: 24),
            
            // Google Button
            googleButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            googleButton.topAnchor.constraint(equalTo: orRegisterLabel.bottomAnchor, constant: 32),
            googleButton.heightAnchor.constraint(equalToConstant: 24),
            googleButton.widthAnchor.constraint(equalToConstant: 24),
            
            // Apple Button
            appleButton.leadingAnchor.constraint(equalTo: googleButton.trailingAnchor, constant: 16),
            appleButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -48),
            appleButton.topAnchor.constraint(equalTo: orRegisterLabel.bottomAnchor, constant: 32),
            appleButton.heightAnchor.constraint(equalToConstant: 24),
            appleButton.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
}

