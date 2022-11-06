//
//  ViewController.swift
//  Collective
//
//  Created by Jaume Pujadas on 7/28/22.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var feedCollectionView: UICollectionView?
    private var feedData: [FeedCellData] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            FirestoreManager.shared.fetchFeed() {result in
                switch result {
                case.success(let results):
                    print(results)
                    self.feedData = results
                    self.feedCollectionView?.reloadData()
                case.failure(let error):
                    print(error)
                }
            }
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.width)
        
        feedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.backgroundColor = .systemBackground
        guard let feedCollectionView = feedCollectionView else {
            return
        }
        feedCollectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)
        feedCollectionView.dataSource = self
        feedCollectionView.delegate = self
        view.addSubview(feedCollectionView)
        feedCollectionView.frame = view.bounds
    }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.parent?.title = "Home"
        DispatchQueue.main.async {
            FirestoreManager.shared.fetchFeed() {result in
                switch result {
                case.success(let results):
                    print(results)
                    self.feedData = results
                    self.feedCollectionView?.reloadData()
                case.failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FeedCollectionViewCell.identifier,
            for: indexPath
        ) as? FeedCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let data = feedData[indexPath.row]
        let imageURL = data.image
        cell.configure(with: FeedCellViewModel(title: data.track_name, author: data.author, artist: data.artist, artworkURL: imageURL))
        cell.layer.cornerRadius = 25
        cell.layer.masksToBounds = true
        
        return cell
    }
}

