//
//  SearchResultsResponse.swift
//  Collective
//
//  Created by Jaume Pujadas on 8/24/22.
//

import Foundation

struct SearchTracksResponse: Codable {
    let tracks: TracksResponse
}

struct TracksResponse: Codable {
    let items: [AudioTrack]
}
