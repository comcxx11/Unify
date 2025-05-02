//
//  LoginService.swift
//  Unify
//
//  Created by Seojin on 5/2/25.
//

import Foundation
import Combine
import Alamofire

struct LoginResponse: Decodable {
    let success: Bool
    let message: String
}

enum LoginServiceEvent {
    case loginResponse(LoginResponse)
}

protocol LoginServiceProtocol {
    func login(username: String, password: String) -> AnyPublisher<LoginResponse, NetworkError>
}

final class LoginService: LoginServiceProtocol {
    
    static let shared = LoginService()
    private init() { }
    
    // {"username": "seojin3", "password": "test1234"}
    func login(username: String, password: String) -> AnyPublisher<LoginResponse, NetworkError> {
        
        let parameters = [
            "username": username, "password": password
        ]
        
        return NetworkManager.shared.request(
            endpoint: .login,
            method: .post,
            parameters: parameters
        )
    }
    
}
