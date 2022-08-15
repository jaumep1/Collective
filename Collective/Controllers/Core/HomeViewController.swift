//
//  ViewController.swift
//  Collective
//
//  Created by Jaume Pujadas on 7/28/22.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        self.navigationController?.parent?.title = "Home"

    }
}

