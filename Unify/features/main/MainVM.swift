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
        let animalsResponsePubliser: AnyPublisher<[Animal], Never>
        let citiesResponsePubliser: AnyPublisher<[City]?, NetworkError>
    }
    
    func transform(from input: Input) -> Output {
        
        input.viewDidLoad
            .sink {
                
            }
            .store(in: &cancellables)
        
        let animalsResponsePubliser = apiEventReceived
            .compactMap { event -> [Animal]? in
                if case let .animalResponse(apiResponse) = event {
                    return apiResponse.data
                }
                return nil
            }
        
        let citiesResponsePubliser = apiEventReceived
            .tryMap { event -> [City]? in
                guard case let .citiesResponse(apiResponse) = event else {
                    throw NetworkError.requestFailed
                }

                
                guard apiResponse.meta.statusCode == 200 else {
                    throw NetworkError.apiError(apiResponse.meta.message)
                }
                
                return apiResponse.data
            }
            .mapError { $0 as? NetworkError ?? .requestFailed }
        
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
            animalsResponsePubliser: animalsResponsePubliser.eraseToAnyPublisher(),
            citiesResponsePubliser: citiesResponsePubliser.eraseToAnyPublisher()
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
            .handleEvents(receiveSubscription: { _ in
                print("🌐 도시 불러오는 중...")
            }, receiveCompletion: { completion in
                print("🔚 Completion: \(completion)")
            })
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    ErrorPopupManager.shared.showError(error)
                    self?.apiEventReceived.send(.citiesFailed(error))
                }
            }, receiveValue: { [weak self] response in
                self?.apiEventReceived.send(.citiesResponse(response))
            })
            .store(in: &cancellables)
    }
}
