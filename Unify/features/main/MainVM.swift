//
//  MainVM.swift
//  Unify
//
//  Created by Seojin on 4/24/25.
//

import Combine
import Foundation

protocol MainVMType {
    func transform(from input: MainVM.Input) -> MainVM.Output
}

final class MainVM: BaseViewModel<MainVM.CoordinatorEvent>, MainVMType {
    
    enum CoordinatorEvent {
        case next
        case notice
    }
    
    let cityEvents = PassthroughSubject<ApiEvent<[City]?>, Never>()
    let animalEvents = PassthroughSubject<ApiEvent<[Animal]?>, Never>()
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let buttonTapped: AnyPublisher<MainV.ButtonEvent, Never>
    }
    
    struct Output {
        let coordinatorEvent: AnyPublisher<CoordinatorEvent, Never>
        let animalsResponsePublisher: AnyPublisher<LoadingState<[Animal]>, Never>
        let citiesResponsePublihser: AnyPublisher<LoadingState<[City]>, Never>
    }
    
    func transform(from input: Input) -> Output {
        
        input.viewDidLoad
            .sink {
                
            }
            .store(in: &cancellables)
        
        let animalsResponsePubliser = animalEvents
            .compactMap { event -> LoadingState? in
                if case let .success(response) = event {
                    if response.meta.statusCode == 200, let animals = response.data {
                        return .success(animals ?? [])
                    } else {
                        return .failure(response.meta)
                    }
                }
                
                if case .loading = event { return .loading }
                if case .idle = event { return .idle }
                if case .failure(let networkError) = event {
                    print("\(networkError.localizedDescription)")
                    return .idle
                }
                return nil
            }
        
        let citiesResponsePublisher = cityEvents
            .compactMap { event -> LoadingState? in
                if case let .success(response) = event {
                    if response.meta.statusCode == 200, let cities = response.data {
                        return .success(cities ?? [])
                    } else {
                        return .failure(response.meta)
                    }
                }
                
                if case .loading = event { return .loading }
                if case .idle = event { return .idle }
                if case .failure(let networkError) = event {
                    print("\(networkError.localizedDescription)")
                    return .idle
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
            .handleApiEvents(on: animalEvents)
            .sink { completion in
                // 실제로는 handleApiEvents에서 처리됐기 때문에 여긴 비워둬도 됨
                print("🧡 \(completion)")
            } receiveValue: { [weak self] response in
                self?.animalEvents.send(.success(response))
            }
            .store(in: &cancellables)

    }
    
    private func fetchCities() {
        // apiEventReceived.send(.loading)
        
        JsonService.shared.cities()
            .handleApiEvents(on: cityEvents)
            .sink { completion in
                // 실제로는 handleApiEvents에서 처리됐기 때문에 여긴 비워둬도 됨
                print("🧡 \(completion)")
            } receiveValue: { [weak self] response in
                self?.cityEvents.send(.success(response))
            }
            .store(in: &cancellables)
    }
}
