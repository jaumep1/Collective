//
//  UserProfile.swift
//  Collective
//
//  Created by Jaume Pujadas on 7/28/22.
//

import Foundation

struct SpotifyUserProfile: Codable{
    let country: String
    let display_name: String
    let email: String
    let id: String
    let product: String
    let images: [UserImage]
}

struct UserImage: Codable {
    let url: String
}
