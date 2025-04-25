//
//  MainVM.swift
//  Unify
//
//  Created by Seojin on 4/24/25.
//

import Combine

protocol MainVMType {
    func transform(from input: MainVM.Input) -> MainVM.Output
}

final class MainVM: MainVMType {
    
    private var cancellables = Set<AnyCancellable>()
    
    enum CoordinatorEvent {
        case next
    }
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let buttonTapped: AnyPublisher<MainV.ButtonEvent, Never>
    }
    
    struct Output {
        let coordinatorEvent: AnyPublisher<CoordinatorEvent, Never>
    }
    
    private let coordinatorEventSubject = PassthroughSubject<CoordinatorEvent, Never>()
    
    func transform(from input: Input) -> Output {
        
        input.viewDidLoad
            .sink {
                
            }
            .store(in: &cancellables)
        
        input.buttonTapped
            .sink { [weak self] in
                switch $0 {
                case .next:
                    self?.coordinatorEventSubject.send(.next)
                }
            }
            .store(in: &cancellables)
        
        return Output(
            coordinatorEvent: coordinatorEventSubject.eraseToAnyPublisher()
        )
        
    }
}
