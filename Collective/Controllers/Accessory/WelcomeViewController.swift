//
//  WelcomeViewController.swift
//  Collective
//
//  Created by Jaume Pujadas on 7/28/22.
//

import UIKit

class WelcomeViewController: UIViewController {

    private let signInButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 25
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.black, for: .normal)

        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Collective"
        view.backgroundColor = .systemBackground
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(x: 20,
                                    y: view.height-50-view.safeAreaInsets.bottom,
                                    width: view.width-40,
                                    height: 50)
        
    }
    
    @objc func didTapSignIn() {
        let vc = AuthViewController()
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(success: Bool) {
        guard success else {
            let alert = UIAlertController(title: "Oops", message: "Something went wrong when signing in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        
        print("WINNING")
         
        let vc = TabBarViewController()
        vc.modalPresentationStyle = .fullScreen
        let mainNav = UINavigationController(rootViewController: vc)
        mainNav.navigationBar.prefersLargeTitles = true
        mainNav.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
        mainNav.modalPresentationStyle = .fullScreen
        present(mainNav, animated: true)
    }

}
