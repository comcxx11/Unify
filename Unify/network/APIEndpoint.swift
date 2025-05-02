//
//  APIEndpoint.swift
//  Unify
//
//  Created by Seojin on 5/2/25.
//

import Foundation

enum APIEndpoint {
    case login
    case animals
    case cities
    
    var url: URL {
        switch self {
        case .login:
            return URL(string: "\(Configs.Network.host)/user/login")!
        case .animals:
            return URL(string: "\(Configs.Network.localhost)/api/json/animals")!
        case .cities:
            return URL(string: "\(Configs.Network.localhost)/api/json/cities")!
        }
    }
}
