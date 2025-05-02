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
    case animalResponse(ApiResponse<[Animal]>)
    case citiesResponse(ApiResponse<[City]>)
}

protocol JsonServiceProtocol {
    func animals() -> AnyPublisher<ApiResponse<[Animal]>, NetworkError>
    func cities() -> AnyPublisher<ApiResponse<[City]>, NetworkError>
}

final class JsonService: JsonServiceProtocol {
    
    static let shared = JsonService()
    private init() { }
    
    func animals() -> AnyPublisher<ApiResponse<[Animal]>, NetworkError> {
        return NetworkManager.shared.request(endpoint: .animals)
    }
    
    func cities() -> AnyPublisher<ApiResponse<[City]>, NetworkError> {
        return NetworkManager.shared.request(endpoint: .cities)
    }
    
}
