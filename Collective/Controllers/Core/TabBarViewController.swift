//
//  TabBarViewController.swift
//  Collective
//
//  Created by Jaume Pujadas on 7/28/22.
//

import FirebaseFirestore
import UIKit

class TabBarViewController: UITabBarController {
    
    let database = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        SpotifyAPICaller.shared.getCurrentUserProfile { result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self.launchTabsWithUserData(user: model)
                    self.database.document("users/" + model.id).getDocument() { snapshot, error in
                        guard snapshot?.data() != nil, error == nil else {
                            self.sendUserToPostView(user: model, userExists: true)
                            return
                        }
                    }
                }
                break
            case .failure(let error):
                print (error.localizedDescription)
            }
        }

    }
    
    private func sendUserToPostView(user: SpotifyUserProfile, userExists: Bool) {
        let vc = PostViewController()
        vc.user = user
        vc.isFirstPost = userExists
        /*
         
         Notes:
         VC takes orders from here first then post vc class --> setup everything there?
         
         watch spotify guy to see how he sets up page --> table with cells?
         
         
         */
        vc.navigationItem.largeTitleDisplayMode = .always
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
            }
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationItem.largeTitleDisplayMode = .always
        nav.navigationController?.modalPresentationStyle = .fullScreen
        self.navigationController?.present(nav, animated: true)

    }
    
    private func launchTabsWithUserData(user: SpotifyUserProfile) {
        let vc1 = FriendsViewController()
        let vc2 = CollectionsViewController()
        let vc3 = HomeViewController()
        let vc4 = ProfileViewController()
        
        vc1.navigationItem.largeTitleDisplayMode = .always
        vc2.navigationItem.largeTitleDisplayMode = .always
        vc3.navigationItem.largeTitleDisplayMode = .always
        vc4.navigationItem.largeTitleDisplayMode = .always
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        let nav4 = UINavigationController(rootViewController: vc4)
        
        nav1.tabBarItem = UITabBarItem(title: "Friends", image: UIImage(systemName: "person.2"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Collections", image: UIImage(systemName: "music.note.list"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav4.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 1)
        
        
        
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.prefersLargeTitles = true
        nav4.navigationBar.prefersLargeTitles = true
        
        setViewControllers([nav1, nav2, nav3, nav4], animated: false)
    }
    
}
