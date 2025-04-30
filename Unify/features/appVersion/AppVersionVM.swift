//
//  AppVersionVM.swift
//  Unify
//
//  Created by Seojin on 4/29/25.
//


import Combine

final class AppVersionVM: BaseViewModel<AppVersionVM.CoordinatorEvent> {
    
    enum CoordinatorEvent {
        case back
    }
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let buttonTapped: AnyPublisher<AppVersionVC.ButtonEvent, Never>
    }
    
    struct Output {
        let coordinator: AnyPublisher<CoordinatorEvent, Never>
    }
    
    override init() {
        print("✅ AppVersionVM initialized")
    }

    deinit {
        print("❌ AppVersionVM deinitialized")
    }

    func transform(input: Input) -> Output {
        
        print("TRANSFORM")
        
        input.viewDidLoad
            .sink {
                print("START")
            }
            .store(in: &cancellables)
        
        input.buttonTapped
            .sink { [weak self] in
                print("BUTTON TAPPED: \($0)")
                switch $0 {
                case .back:
                    print("SEND COORDINATOR BACK")
                    self?.coordinatorEventSubject.send(.back)
                }
            }
            .store(in: &cancellables)
        
        return Output(coordinator: coordinatorEventSubject.eraseToAnyPublisher())
    }
}
