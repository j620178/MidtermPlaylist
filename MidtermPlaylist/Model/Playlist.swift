//
//  Playlist.swift
//  MidtermPlaylist
//
//  Created by littlema on 2019/8/23.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

struct TokenInfo: Decodable {
    var accessToken: String
    var tokenType: String
    var expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}

struct Playlist: Decodable {
    var data: [Song]
    var paging: PagingInfo
    var summary: Summary
}

struct Song: Decodable {
    let id: String
    let name: String
    let album: Album
}

struct Album: Decodable {
    let id: String
    let images: [AlbumImage]
}

struct AlbumImage: Decodable {
    let url: String
}

struct PagingInfo: Decodable {
    let offset: Int
    let limit: Int
    let previous: String?
    let next: String?
}

struct Summary: Decodable {
    let total: Int
}
