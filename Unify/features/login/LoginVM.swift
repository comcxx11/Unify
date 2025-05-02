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
            .sink { [weak self] in
                switch $0 {
                case .login:
                    self?.login()
                }
            }
            .store(in: &cancellables)
        
        return Output(
            coordinator: coordinatorEventSubject.eraseToAnyPublisher()
        )
        
    }
    
    private func login() {
        LoginService.shared.login(username: "seojin3", password: "test1234")
            .sink { [weak self] completion in
                print("Login Complete...")
                self?.coordinatorEventSubject.send(.login)
            } receiveValue: { response in
                print(response)
            }
            .store(in: &cancellables)

    }
}
