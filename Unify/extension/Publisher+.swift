//
//  Publisher.swift
//  Unify
//
//  Created by Seojin on 5/2/25.
//

import Combine
import Foundation

extension Publisher where Failure == NetworkError {
    func handleApiEvents<T: Decodable>(
        for type: T.Type = T.self,
        on subject: PassthroughSubject<ApiEvent<T>, Never>
    ) -> AnyPublisher<ApiResponse<T>, NetworkError> where Output == ApiResponse<T> {
        
        subject.send(ApiEvent.loading)

        return self
            .handleEvents(
                receiveOutput: { response in
                    subject.send(.success(response))
                },
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        subject.send(.idle)
                    case .failure(let error):
                        subject.send(.failure(error))
                    }
                },
                receiveCancel: {
                    subject.send(.idle)
                }
            )
            .eraseToAnyPublisher()
    }
    
    /// API 결과를 `ApiEvent<T>` 스트림으로 변환한 뒤
    ///   - loading  → prepend 로 먼저 발사
    ///   - success  → .success(response)
    ///   - failure  → .failure(NetworkError)  로 매핑
    ///   - idle     → 마지막에 append
    func asApiEvent<T>() -> AnyPublisher<ApiEvent<T>, Never>
    where Output == ApiResponse<T>, Failure == NetworkError {
        
        let loading = Just(ApiEvent<T>.loading)
        
        let request = self
            .map { ApiEvent<T>.success($0) }            // ✅ 정상 응답
            .catch { Just(ApiEvent<T>.failure($0)) }    // ✅ 네트워크 에러
            .eraseToAnyPublisher()
        
        let idle = Just(ApiEvent<T>.idle)
        
        // loading → request 결과 → idle 순서로 방출
        return loading
            .append(request)
            .append(idle)
            .eraseToAnyPublisher()
    }
}

extension Publisher where Failure == Never {

    /// ApiEvent<T> → LoadingState<T> 변환
    func toLoadingState<T>() -> AnyPublisher<LoadingState<T>, Never>
    where Output == ApiEvent<T> {          // ← 함수 레벨에서 Output 제약
        self
            .map { event -> LoadingState<T> in
                switch event {
                case let .success(response):
                    if response.meta.statusCode == 200,
                       let data = response.data {
                        return .success(data)
                    } else {
                        return .failure(response.meta)
                    }

                case .loading:
                    return .loading
                case .idle:
                    return .idle

                case let .failure(error):
                    _ = print(error.localizedDescription)
                    return .idle
                }
            }
            .eraseToAnyPublisher()
    }
}
