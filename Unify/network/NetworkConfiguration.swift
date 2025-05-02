//
//  NetworkConfiguration.swift
//  Unify
//
//  Created by Seojin on 5/2/25.
//

import Foundation

struct NetworkConfiguration {
    static let timeoutInterval: TimeInterval = 30
    
    static func commonHeaders() -> [String: String] {
        var headers: [String: String] = [
            "Content-Type": "application/json"
        ]
        
        if let accessToken = TokenStorage.shared.accessToken {
            headers["Authorization"] = "Bearer \(accessToken)"
        }
        
        return headers
    }
}
