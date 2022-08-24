//
//  FirebaseManager.swift
//  Collective
//
//  Created by Jaume Pujadas on 8/24/22.
//

import FirebaseFirestore
import Foundation

final class FirestoreManager {
    
    static let shared = FirestoreManager()
    
    private let database = Firestore.firestore()

    private init() {}
    
    public func hasUserPosted(with model: SpotifyUserProfile, completion: @escaping (Bool) -> Void) {
        self.database.document("users/" + model.id).getDocument { snapshot, error in
            guard snapshot?.data() != nil, error == nil else {
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
            "album": [
                "album_name": data.album.name,
                "album_id": data.album.id,
            ],
            "available_markets": data.available_markets,
            "disc_number": data.disc_number,
            "duration_ms": data.duration_ms,
            "explicit": data.explicit,
            "popularity_score": data.popularity,
            "external_urls": data.external_urls,
            "image": data.album.images.first?.url,
        ])
    }
}
