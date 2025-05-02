//
//  MainService.swift
//  Unify
//
//  Created by Seojin on 5/2/25.
//


import Foundation
import Combine
import Alamofire

protocol JsonServiceProtocol {
    func animals() -> AnyPublisher<ApiResponse<[Animal]?>, NetworkError>
    func cities() -> AnyPublisher<ApiResponse<[City]?>, NetworkError>
}

final class JsonService: JsonServiceProtocol {
    
    func animals() -> AnyPublisher<ApiResponse<[Animal]?>, NetworkError> {
        return NetworkManager.shared.request(endpoint: .animals)
    }
    
    func cities() -> AnyPublisher<ApiResponse<[City]?>, NetworkError> {
        return NetworkManager.shared.request(endpoint: .cities)
    }
    
}
