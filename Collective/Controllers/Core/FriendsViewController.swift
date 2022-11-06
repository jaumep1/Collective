//
//  FriendsViewController.swift
//  Collective
//
//  Created by Jaume Pujadas on 7/28/22.
//

import UIKit

class FriendsViewController: UIViewController {

    private let headline: UILabel = {
        let label = UILabel()
        label.text = "Welcome to our Beta! If you're here, so are your friends -- more coming soon!"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLoad()
        headline.frame = CGRect(x: 50 , y: (view.frame.size.height/2)-50, width: (view.frame.size.width) - 100, height: 50)
        view.addSubview(headline)
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.parent?.title = "Friends"
    }

}
