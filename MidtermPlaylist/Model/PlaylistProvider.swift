//
//  PlaylistProvider.swift
//  MidtermPlaylist
//
//  Created by littlema on 2019/8/23.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

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
    
    func getPlaylist(accessToken: String, offset: String?, completion: @escaping (Result<Playlist, RestAPIError>) -> Void) {
        HttpClinet.shared.request(PlaylistRequest.getPlaylist(accessToken: accessToken, offset: offset).makeRequest()) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                do {
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
