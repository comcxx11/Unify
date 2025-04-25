//
//  IntroVM.swift
//  Unify
//
//  Created by Seojin on 4/7/25.
//

import Combine

final class IntroVM: BaseViewModel<IntroVM.CoordinatorEvent> {
    
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
        
        input.viewDidLoad
            .sink { [weak self] in
                self?.coordinatorEventSubject.send(.launch)
            }
            .store(in: &cancellables)
        
        return Output(coordinator: coordinatorEventSubject.eraseToAnyPublisher())
    }
}
