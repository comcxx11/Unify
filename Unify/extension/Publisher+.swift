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
}
