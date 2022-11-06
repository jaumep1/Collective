//
//  AudioTrack.swift
//  Collective
//
//  Created by Jaume Pujadas on 8/24/22.
//

import Foundation
import FirebaseFirestoreSwift

struct FeedCellData: Codable {
    let author: String
    let track_name: String
    let artist: String
    let image: URL
    let timestamp: Double
}
