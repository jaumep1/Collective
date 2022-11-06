//
//  FirebaseManager.swift
//  Collective
//
//  Created by Jaume Pujadas on 8/24/22.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

final class FirestoreManager {
    
    static let shared = FirestoreManager()
    
    private let database = Firestore.firestore()

    private init() {}
    
    public func hasUserPosted(with model: SpotifyUserProfile, completion: @escaping (Bool) -> Void) {
        self.database.document("feed/" + model.id).getDocument { snapshot, error in
            guard snapshot?.data() != nil, error == nil else {
                completion(false)
                return
            }
            do {
                let result = try snapshot?.data(as: FeedCellData.self)
                if (NSDate().timeIntervalSince1970 - result!.timestamp > 7200) {
                    completion(false)
                    return
                }
            } catch {
                print(error)
                completion(false)
                return
            }
            completion(true)
        }
    }
        
    public func postNewPost(with model: SpotifyUserProfile, data: AudioTrack) {
        var numPosts = 0
        
        self.database.collection("users").document(model.id).getDocument() { snapshot, error in
            guard let userData = snapshot?.data(), error == nil else {
                self.post(with: model, data: data, numPosts: numPosts)
                return
            }
            numPosts = userData["num_posts"] as! Int
            self.post(with: model, data: data, numPosts: numPosts)
        }
    }
    
    private func post(with model: SpotifyUserProfile, data: AudioTrack, numPosts: Int) {
        self.database
            .collection("users")
            .document(model.id)
            .setData(["num_posts": numPosts+1])
        
        self.database
            .collection("users")
            .document(model.id)
            .collection("posts")
            .document(String(numPosts))
            .setData(
        [
            "track_name": data.name,
            "track_id": data.id,
            "album_name":  data.album.name,
            "album_id":  data.album.id,
            "artist": data.artists.first?.name,
            "artist_id": data.artists.first?.id,
            "available_markets": data.available_markets,
            "disc_number": data.disc_number,
            "duration_ms": data.duration_ms,
            "explicit": data.explicit,
            "popularity_score": data.popularity,
            "external_urls": data.external_urls,
            "image": data.album.images.first?.url,
            "timestamp": NSDate().timeIntervalSince1970
        ])
        postToFeed(with: model, data: data)
    }
    
    private func postToFeed(with model: SpotifyUserProfile, data: AudioTrack) {
        self.database
            .collection("feed")
            .document(model.id)
            .setData(
            [
                "author": model.display_name,
                "track_name": data.name,
                "track_id": data.id,
                "album_name":  data.album.name,
                "album_id":  data.album.id,
                "artist": data.artists.first?.name,
                "artist_id": data.artists.first?.id,
                "available_markets": data.available_markets,
                "disc_number": data.disc_number,
                "duration_ms": data.duration_ms,
                "explicit": data.explicit,
                "popularity_score": data.popularity,
                "external_urls": data.external_urls,
                "image": data.album.images.first?.url,
                "timestamp": NSDate().timeIntervalSince1970
            ])
    }

    
    public func fetchFeed(completion: @escaping (Result<[FeedCellData], Error>) -> Void) {
        self.database.collection("feed").getDocuments() { snapshot, error in
            guard snapshot?.documents != nil, error == nil else {
                completion(.failure("ERROR FETCHING FEED" as! Error))
                return
            }
            
            var results:[FeedCellData] = []
            
            for document in snapshot!.documents {
//                print("\(document.documentID) => \(document.data())")
                do {
                    let result = try document.data(as: FeedCellData.self)
                    results.append(result)
                } catch {
                    print(error)
                }
                
            }
            completion(.success(results))
        }
    }
}
