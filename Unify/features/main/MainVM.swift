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
    
    private var apiEventReceived = PassthroughSubject<JsonServiceEvent, Never>()
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let buttonTapped: AnyPublisher<MainV.ButtonEvent, Never>
    }
    
    struct Output {
        let coordinatorEvent: AnyPublisher<CoordinatorEvent, Never>
        let animalsResponsePublisher: AnyPublisher<ApiResponse<[Animal]?>, Never>
        let citiesResponsePublihser: AnyPublisher<ApiResponse<[City]?>, Never>
    }
    
    func transform(from input: Input) -> Output {
        
        input.viewDidLoad
            .sink {
                
            }
            .store(in: &cancellables)
        
        let animalsResponsePubliser = apiEventReceived
            .compactMap { event -> ApiResponse<[Animal]?>? in
                if case let .animalResponse(response) = event {
                    return response
                }
                return nil
            }
        
        let citiesResponsePublisher = apiEventReceived
            .compactMap { event -> ApiResponse<[City]?>? in
                if case let .citiesResponse(response) = event {
                    return response
                }
                return nil
            }
        
        input.buttonTapped
            .sink { [weak self] in
                switch $0 {
                case .next:
                    self?.coordinatorEventSubject.send(.notice)
                case .animals:
                    self?.fetchAnimals()
                case .cities:
                    self?.fetchCities()
                }
            }
            .store(in: &cancellables)
        
        return Output(
            coordinatorEvent: coordinatorEventSubject.eraseToAnyPublisher(),
            animalsResponsePublisher: animalsResponsePubliser.eraseToAnyPublisher(),
            citiesResponsePublihser: citiesResponsePublisher.eraseToAnyPublisher()
        )
        
    }
}

extension MainVM {
    
    private func fetchAnimals() {
        print("fetch ...")
        JsonService.shared.animals()
            .sink {completion in
                print("com \(completion)")
            } receiveValue: {  [weak self] response in
                self?.apiEventReceived.send(.animalResponse(response))
            }
            .store(in: &cancellables)

    }
    
    private func fetchCities() {
        JsonService.shared.cities()
            .sink {completion in
                print("com \(completion)")
            } receiveValue: {  [weak self] response in
                self?.apiEventReceived.send(.citiesResponse(response))
            }
            .store(in: &cancellables)
    }
}
