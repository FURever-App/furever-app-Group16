//
//  SplashViewController.swift
//  FinalProject_Group16
//
//  Created by Zhiyu Li on 11/28/24.
//

import UIKit

class SplashViewController: UIViewController {

    private let splashView = SplashScreenView()

    override func loadView() {
        // Set the main view to the custom view
        self.view = splashView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startSplashTimer()
    }

    // MARK: - Splash Timer

    func startSplashTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.goToMainScreen()
        }
    }

    private func goToMainScreen() {
        let mainVC = ViewController()
        Utils.transitionToMainScreen(from: self, mainVC: mainVC)
    }
}

