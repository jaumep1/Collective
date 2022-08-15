//
//  NewReleasesResponse.swift
//  Collective
//
//  Created by Jaume Pujadas on 8/14/22.
//

import Foundation

struct NewReleasesResponse: Codable {
    let albums: AlbumsResponse
}

struct AlbumsResponse: Codable {
    let items: [Album]
}

struct Album: Codable {
    let albumType: String
    let availableMarkets: [String]
    let id: String
    let images: [ImageFromAPI]
    let name: String
    let releaseDate: String
    let totalTracks: Int
    let artists: [Artist]
}

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    
}
