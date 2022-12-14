//
//  SearchResultsViewController.swift
//  Collective
//
//  Created by Jaume Pujadas on 8/17/22.
//

import UIKit

class SearchResultsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    private var results: [AudioTrack] = []
    private var selectedCell: IndexPath = IndexPath()
    public var user: SpotifyUserProfile? = nil

    
    public var completionHandler: ((Bool) -> Void)?
    
    private let postButton:UIButton = {
        let button = UIButton()
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.isHidden = true;
        button.layer.cornerRadius = 20
        return button
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
        collectionView.isHidden = true
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(collectionView)
        view.addSubview(postButton)
        collectionView.delegate = self
        collectionView.dataSource = self
        postButton
            .addTarget(self, action: #selector(didTapPost), for: .touchUpInside)

        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        postButton.frame = CGRect(x: 20,
                                    y: view.height-50-view.safeAreaInsets.bottom,
                                    width: view.width-40,
                                    height: 50)
    }
    
    func update(with results: [AudioTrack]) {
        self.results = results
        collectionView.reloadData()
        collectionView.isHidden = results.isEmpty
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
