//
//  PlaylistProvider.swift
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

class PlaylistProvider {
    let decoder = JSONDecoder()
    
    func getToken(completion: @escaping (Result<TokenInfo, RestAPIError>) -> Void) {
        HttpClinet.shared.request(PlaylistRequest.getToken.makeRequest()) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                do {
                    let response = try strongSelf.decoder.decode(TokenInfo.self, from: data)
                    completion(Result.success(response))
                } catch {
                    completion(Result.failure(RestAPIError.decodeError))
                }
            case .failure(_):
                completion(Result.failure(RestAPIError.unexpectedError))
            }
        }
    }
    
    func getPlaylist(offset: Int, completion: @escaping (Result<Playlist, RestAPIError>) -> Void) {
        HttpClinet.shared.request(PlaylistRequest.getPlaylist(accessToken: "zKAFsLwvMpGpiyIqsw7YtQ==", offset: "\(offset)").makeRequest()) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                do {
                    let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
                    print(jsonData)
                    let response = try strongSelf.decoder.decode(Playlist.self, from: data)
                    completion(Result.success(response))
                } catch {
                    completion(Result.failure(RestAPIError.decodeError))
                    print(error)
                }
            case .failure(_):
                completion(Result.failure(RestAPIError.unexpectedError))
            }
        }
    }
    
}
