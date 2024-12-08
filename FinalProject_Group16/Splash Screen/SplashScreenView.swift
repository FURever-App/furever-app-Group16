//
//  SplashScreenView.swift
//  FinalProject_Group16
//
//  Created by Zhiyu Li on 11/28/24.
//

import UIKit

class SplashScreenView: UIView {
    var logoImageView: UIImageView!
    var appTitleLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(
            red: 207/255.0,
            green: 178/255.0,
            blue: 159/255.0,
            alpha: 255/255.0 // Alpha is 1.0 for full opacity
        )

        setupLogoImageView()
        setupAppTitleLabel()
        initConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI Components

    func setupLogoImageView() {
        logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "app_logo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(logoImageView)
    }

    func setupAppTitleLabel() {
        appTitleLabel = UILabel()
        appTitleLabel.text = "Welcome to FURever!" 
        appTitleLabel.font = UIFont(name: "Modak", size: 36)
        appTitleLabel.textColor = .black
        appTitleLabel.textAlignment = .center
        appTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(appTitleLabel)
    }

    // MARK: - Setup Constraints

    func initConstraints() {
        NSLayoutConstraint.activate([
            // Logo ImageView Constraints
            logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -40),
            logoImageView.widthAnchor.constraint(equalToConstant: 350),
            logoImageView.heightAnchor.constraint(equalToConstant: 350),

            // App Title Label Constraints
            appTitleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 32),
            appTitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
}

