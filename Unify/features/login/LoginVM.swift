//
//  LoginVM.swift
//  Unify
//
//  Created by Seojin on 5/2/25.
//


import Combine

protocol LoginVMType {
    func transform(from input: LoginVM.Input) -> LoginVM.Output
}

final class LoginVM: BaseViewModel<LoginVM.CoordinatorEvent>, LoginVMType {
    
    enum CoordinatorEvent {
        case login
    }
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let buttonTapped: AnyPublisher<LoginV.ButtonEvent, Never>
    }
    
    struct Output {
        let coordinator: AnyPublisher<CoordinatorEvent, Never>
    }
    
    func transform(from input: Input) -> Output {
        
        input.viewDidLoad
            .sink {
                
            }
            .store(in: &cancellables)
        
        input.buttonTapped
            .sink {
                switch $0 {
                case .back:
                    break
                }
            }
            .store(in: &cancellables)
        
        return Output(
            coordinator: coordinatorEventSubject.eraseToAnyPublisher()
        )
        
    }
}
