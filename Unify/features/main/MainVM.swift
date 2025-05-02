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
    
    private var apiEventReceived = PassthroughSubject<ApiEvent<[City]?>, Never>()
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let buttonTapped: AnyPublisher<MainV.ButtonEvent, Never>
    }
    
    struct Output {
        let coordinatorEvent: AnyPublisher<CoordinatorEvent, Never>
//        let animalsResponsePublisher: AnyPublisher<ApiResponse<[Animal]?>, Never>
        let citiesResponsePublihser: AnyPublisher<LoadingState<[City]>, Never>
    }
    
    func transform(from input: Input) -> Output {
        
        input.viewDidLoad
            .sink {
                
            }
            .store(in: &cancellables)
        
//        let animalsResponsePubliser = apiEventReceived
//            .compactMap { event -> ApiResponse<[Animal]?>? in
//                if case let .animalResponse(response) = event {
//                    return response
//                }
//                return nil
//            }
        
        let citiesResponsePublisher = apiEventReceived
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
                    break
                    //self?.fetchAnimals()
                case .cities:
                    self?.fetchCities()
                }
            }
            .store(in: &cancellables)
        
        return Output(
            coordinatorEvent: coordinatorEventSubject.eraseToAnyPublisher(),
//            animalsResponsePublisher: animalsResponsePubliser.eraseToAnyPublisher(),
            citiesResponsePublihser: citiesResponsePublisher.eraseToAnyPublisher()
        )
        
    }
}

extension MainVM {
//    
//    private func fetchAnimals() {
//        print("fetch ...")
//        JsonService.shared.animals()
//            .sink {completion in
//                print("com \(completion)")
//            } receiveValue: {  [weak self] response in
//                self?.apiEventReceived.send(.animalResponse(response))
//            }
//            .store(in: &cancellables)
//
//    }
//    
    private func fetchCities() {
        // apiEventReceived.send(.loading)
        
        JsonService.shared.cities()
            .handleApiEvents(on: apiEventReceived)
            .sink { completion in
                // 실제로는 handleApiEvents에서 처리됐기 때문에 여긴 비워둬도 됨
                print("🧡 \(completion)")
            } receiveValue: { [weak self] response in
                self?.apiEventReceived.send(.success(response))
            }
            .store(in: &cancellables)
    }
}
