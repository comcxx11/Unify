//
//  IntroVM.swift
//  Unify
//
//  Created by Seojin on 4/7/25.
//

import Combine

final class IntroVM: BaseViewModel {
    
    enum CoordinatorEvent {
        case launch
    }
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let coordinator: AnyPublisher<CoordinatorEvent, Never>
    }
    
    override init() {
        
    }
    
    func transform(input: Input) -> Output {
        
        let coordinatorSubject = PassthroughSubject<CoordinatorEvent, Never>()
        
        input.viewDidLoad
            .sink {
                coordinatorSubject.send(.launch)
            }
            .store(in: &cancellables)
        
        return Output(coordinator: coordinatorSubject.eraseToAnyPublisher())
    }
}
