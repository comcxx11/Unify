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

final class MainVM: BaseViewModel<MainVM.CoordinatorEvent>, MainVMType {
    
    enum CoordinatorEvent {
        case next
        case notice
    }
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let buttonTapped: AnyPublisher<MainV.ButtonEvent, Never>
    }
    
    struct Output {
        let coordinatorEvent: AnyPublisher<CoordinatorEvent, Never>
    }
    
    func transform(from input: Input) -> Output {
        
        input.viewDidLoad
            .sink {
                
            }
            .store(in: &cancellables)
        
        input.buttonTapped
            .sink { [weak self] in
                switch $0 {
                case .next:
                    self?.coordinatorEventSubject.send(.notice)
                case .animals:
                    self?.fetchAnimals()
                }
            }
            .store(in: &cancellables)
        
        return Output(
            coordinatorEvent: coordinatorEventSubject.eraseToAnyPublisher()
        )
        
    }
    
    private func fetchAnimals() {
        print("fetch ...")
        JsonService.shared.animals()
            .sink { completion in
                print("com \(completion)")
            } receiveValue: { response in
                print(response)
            }
            .store(in: &cancellables)

    }
}
