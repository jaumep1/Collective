//
//  PostViewController.swift
//  Collective
//
//  Created by Jaume Pujadas on 8/13/22.
//

import UIKit

class PostViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {

    public var completionHandler: ((Bool) -> Void)?
    public var user: SpotifyUserProfile? = nil
    
    let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultsViewController())
        vc.searchBar.placeholder = "Find Songs"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _,_ -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2,
                                                         leading: 2,
                                                         bottom: 2,
                                                         trailing: 2)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(180)), subitem: item, count: 2)
            
            return NSCollectionLayoutSection(group: group)
        }))
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "POST"

        navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        view.addSubview(collectionView)
        collectionView.register(AudioTrackCollectionViewCell.self, forCellWithReuseIdentifier: AudioTrackCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        
        
//        DispatchQueue.main.async { self.completionHandler?(true)    }
    
/*
 THIS CHUNK SENDS BACK TO MAIN APP
 DispatchQueue.main.async { self.completionHandler?(true)    }
 */

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        resultsController.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
            }
        }
        
        SpotifyAPICaller.shared.searchTracks(query: query) { result in
            DispatchQueue.main.async {
                switch result {
                case.success(let results):
                    print(results)
                    resultsController.update(with: results)
                case.failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
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

extension PostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AudioTrackCollectionViewCell.identifier,
            for: indexPath
        ) as? AudioTrackCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .systemGreen
        cell.configure(with: AudioTrackCollectionViewCellViewModel(title: "title coming soon", artworkURL: nil))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
}
