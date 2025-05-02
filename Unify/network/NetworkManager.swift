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
        
        return AF.request(endpoint.url,
                          method: method,
                          parameters: parameters,
                          encoding: encoding,
                          headers: headers)
            .validate()
            .responseData { response in
                if let data = response.data {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("📦 Raw JSON Response: \n\(jsonString)")
                    }
                }
            }
            .publishDecodable(type: T.self)
            .value()
            // 테스트를 위해 지연
            .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
            // AFError를 NetworkError로 매핑
            .mapError { error in
                self.handleError(error)
            }
            // 에러 발생 시 팝업 표시와 로딩 상태 감소 처리
            .handleEvents(receiveCompletion: { completion in
                // 요청 완료 시 로딩 카운터 감소
                LoadingManager.shared.decrement()
                if case .failure(let error) = completion {
                    // 에러가 발생한 경우 전역 에러 팝업 표시
                    // TODO: 추후에 각 feature 에 옮겨야 할 수도 있음
                    ErrorPopupManager.shared.showError(error)
                }
            }, receiveCancel: {
                LoadingManager.shared.decrement()
            })
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
            print("🕹️ [ERA : \(responseCode)]")
            return .requestFailed
        }
    }
}
