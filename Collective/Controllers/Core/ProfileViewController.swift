//
//  ProfileViewController.swift
//  Collective
//
//  Created by Jaume Pujadas on 7/28/22.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.parent?.title = "Profile"
    }

}
