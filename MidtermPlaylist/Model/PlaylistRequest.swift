//
//  PlaylistRequest.swift
//  MidtermPlaylist
//
//  Created by littlema on 2019/8/23.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

enum PlaylistRequest: RestAPIRequest {
    
    case getToken
    
    case getPlaylist(accessToken: String, offset: String?)
    
    var header: [String: String] {
        switch self {
        case .getToken: return [HttpHeaderKey.contentType.rawValue: HttpHeaderValue.formData.rawValue]
        case .getPlaylist(let accessToken, _): return [HttpHeaderKey.authorization.rawValue: "Bearer \(accessToken)"]
        }
    }
    
    var body: Data? {
        switch self {
        case .getToken:
            let parameters = [
                "grant_type": "client_credentials",
                "client_id": "a82392f4fbfae178f53b08cb5cf9a499",
                "client_secret": "aed8544b9029c3da622694e127532143"
            ]
            return try? createBody(with: parameters, boundary: "----WebKitFormBoundary7MA4YWxkTrZu0gW")
        case .getPlaylist: return nil
        }
    }
    
    var method: String {
        switch self {
        case .getToken:
            return HttpMethod.POST.rawValue
        case .getPlaylist:
            return HttpMethod.GET.rawValue
        }
    }
    
    var url: String {
        switch self {
        case .getToken:
            return "https://account.kkbox.com/oauth2/token"
        case .getPlaylist(_, let offset):
            if let offset = offset {
                return offset
            } else {
                return "https://api.kkbox.com/v1.1/new-hits-playlists/DZrC8m29ciOFY2JAm3/tracks?territory=TW&offset=0&limit=20"
            }
        }
    }
    
    private func createBody(with parameters: [String: String]?, boundary: String) throws -> Data {
        var body = Data()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }
        
        body.append("--\(boundary)--\r\n")
        return body
    }
    
}
