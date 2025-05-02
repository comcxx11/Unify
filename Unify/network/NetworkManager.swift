//
//  NetworkManager.swift
//  Unify
//
//  Created by Seojin on 5/2/25.
//

import Foundation
import Alamofire
import Combine

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func request<T: Decodable>(
        endpoint: APIEndpoint,
        method: HTTPMethod = .get,
        parameters: [String: Any]? = nil,
        delay: Int = 1,
        headers: HTTPHeaders? = HTTPHeaders(NetworkConfiguration.commonHeaders())
    ) -> AnyPublisher<T, NetworkError> {
        let encoding: ParameterEncoding = method == .get ? URLEncoding.default : JSONEncoding.default
        
        // 요청 시작 시 로딩 카운터 증가
        LoadingManager.shared.increment()
                
        // 📌 요청 디버깅용 프린트 추가
        print("""
        🚀 [Request]
        URL: \(endpoint.url)
        Method: \(method.rawValue)
        Headers: \(headers?.dictionary ?? [:])
        Parameters: \(parameters ?? [:])
        """)
        
        return Future<T, NetworkError> { promise in
            AF.request(endpoint.url,
                       method: method,
                       parameters: parameters,
                       encoding: encoding,
                       headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                
                defer {
                    LoadingManager.shared.decrement()
                }
                
                if let data = response.data,
                   let jsonString = String(data: data, encoding: .utf8) {
                    print("📦 Raw JSON Response: \n\(jsonString)")
                }
                
                switch response.result {
                case .success(let value):
                    if let httpResponse = response.response {
                        let accessToken = httpResponse.headers["Authorization"]
                        let refreshToken = httpResponse.headers["RefreshToken"]
                        
                        // 저장
                        TokenStorage.shared.save(accessToken: accessToken, refreshToken: refreshToken)
                    }
                    promise(.success(value))
                    
                case .failure(let afError):
                    let networkError = self.handleError(afError)
                    ErrorPopupManager.shared.showError(networkError)
                    promise(.failure(networkError))
                }
            }
        }
        .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    private func handleError(_ error: AFError) -> NetworkError {
        print("error[\(error.localizedDescription)]")
        if let urlError = error.underlyingError as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                return .requestFailed
            case .timedOut:
                return .serverError
            default:
                return .badURL
            }
        }
        
        let responseCode = error.responseCode ?? -1
        switch responseCode {
        case 401:
            return .unauthorized
        case 500...599:
            return .serverError
        default:
            print("🕹️ [ERA : \(responseCode)] \(error.localizedDescription)")
            return .requestFailed
        }
    }
}
