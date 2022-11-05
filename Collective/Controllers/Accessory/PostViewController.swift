//
//  PostViewController.swift
//  Collective
//
//  Created by Jaume Pujadas on 8/13/22.
//

import UIKit

class PostViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {

    private var results: [AudioTrack] = []
    private var selectedCell: IndexPath = IndexPath()
    public var completionHandler: ((Bool) -> Void)?
    public var user: SpotifyUserProfile? = nil
    
    private let postButton:UIButton = {
        let button = UIButton()
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.isHidden = true;
        button.layer.cornerRadius = 20
        return button
    }()
    
    let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultsViewController())
        vc.searchBar.placeholder = "Find Songs"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _,_ -> NSCollectionLayoutSection? in
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 5,
                                                             leading: 20,
                                                             bottom: 5,
                                                             trailing: 20)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.25)), subitem: item, count: 2)
                
                return NSCollectionLayoutSection(group: group)
            }))
        
        collectionView.register(AudioTrackCollectionViewCell.self, forCellWithReuseIdentifier: AudioTrackCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
        
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
        view.addSubview(postButton)
        postButton
            .addTarget(self, action: #selector(didTapPost), for: .touchUpInside)
        
        SpotifyAPICaller.shared.getUserRecentTracks() { result in
            DispatchQueue.main.async {
                switch result {
                case.success(let results):
                    print(results)
                    self.results = results
                    self.collectionView.reloadData()
                case.failure(let error):
                    print(error)
                }
            }
        }
        
//        DispatchQueue.main.async { self.completionHandler?(true)    }
    
/*
 THIS CHUNK SENDS BACK TO MAIN APP
 DispatchQueue.main.async { self.completionHandler?(true)    }
 */

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        postButton.frame = CGRect(x: 20,
                                    y: view.height-50-view.safeAreaInsets.bottom,
                                    width: view.width-40,
                                    height: 50)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        resultsController.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.completionHandler?(success)
            }
        }
        resultsController.user = self.user
        
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
        
        let track = results[indexPath.row]
        let imageURL = track.album.images.first?.url ?? nil
        if (imageURL != nil) {
            cell.configure(with: AudioTrackCollectionViewCellViewModel(title: track.name, artworkURL: URL(string: imageURL!)))
        } else {
            cell.configure(with: AudioTrackCollectionViewCellViewModel(title: track.name, artworkURL: nil))
        }
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: selectedCell, animated: false)
        (collectionView.cellForItem(at: selectedCell) as? AudioTrackCollectionViewCell)?.disableBorder()
        if (selectedCell != indexPath) {
            selectedCell = indexPath
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
            let cell = collectionView.cellForItem(at: indexPath) as? AudioTrackCollectionViewCell
            cell?.enableBorder()
            showPostButton()
        } else {
            selectedCell = IndexPath()
            dismissPostButton()
        }
    }
    
    func showPostButton() {
        postButton.isHidden = false
    }

    func dismissPostButton() {
        postButton.isHidden = true
    }

    @objc func didTapPost() {
        DispatchQueue.main.async {
            FirestoreManager.shared.postNewPost(with: self.user!, data: self.results[self.selectedCell.row])
            self.dismiss(animated: true)
            self.completionHandler?(true)
        }
    }
}


