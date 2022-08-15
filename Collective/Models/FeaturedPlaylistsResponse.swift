//
//  FeaturedPlaylistsResponse.swift
//  Collective
//
//  Created by Jaume Pujadas on 8/14/22.
//

import Foundation

struct FeaturedPlaylistsResponse: Codable {
    let playlists: PlaylistResponse
}

struct PlaylistResponse: Codable {
    let items: [Playlist]
}

struct Playlist: Codable {
    let description: String
    let id: String
    let images: [ImageFromAPI]
    let name: String
}
