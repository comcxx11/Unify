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
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer YOUR_API_KEY"
        ]
    }
}
