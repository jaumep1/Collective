//
//  PostViewController.swift
//  Collective
//
//  Created by Jaume Pujadas on 8/13/22.
//

import UIKit

class PostViewController: UIViewController {

    public var completionHandler: ((Bool) -> Void)?
    public var user: SpotifyUserProfile? = nil
    
    let searchController: UISearchController = {
        let results = UIViewController()
        results.view.backgroundColor = .red
        let vc = UISearchController(searchResultsController: results)
        vc.searchBar.placeholder = "Find Songs"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "POST"
        

        navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemBackground
        navigationItem.searchController = searchController


        
/*
 THIS CHUNK SENDS BACK TO MAIN APP
 DispatchQueue.main.async { self.completionHandler?(true)    }
 */

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
