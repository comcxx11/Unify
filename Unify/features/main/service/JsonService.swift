//
//  MainService.swift
//  Unify
//
//  Created by Seojin on 5/2/25.
//


import Foundation
import Combine
import Alamofire

struct JsonResponse: Decodable {
    let success: Bool
    let message: String
}

enum JsonServiceEvent {
    case loginResponse(LoginResponse)
}

protocol JsonServiceProtocol {
    func animals() -> AnyPublisher<JsonResponse, NetworkError>
}

final class JsonService: JsonServiceProtocol {
    
    static let shared = JsonService()
    private init() { }
    
    func animals() -> AnyPublisher<JsonResponse, NetworkError> {
        return NetworkManager.shared.request(endpoint: .animals)
    }
    
}
