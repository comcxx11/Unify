//
//  MainVM.swift
//  Unify
//
//  Created by Seojin on 4/24/25.
//

import Combine
import CombineExt
import Foundation

protocol MainVMType {
    func transform(from input: MainVM.Input) -> MainVM.Output
}

final class MainVM: BaseViewModel<MainVM.CoordinatorEvent>, MainVMType {
    
    enum CoordinatorEvent {
        case next
        case notice
    }
    
    // MARK: - I/O 정의
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let buttonTapped: AnyPublisher<MainV.ButtonEvent, Never>
    }
    struct Output {
        let coordinatorEvent: AnyPublisher<CoordinatorEvent, Never>
        let animalsResponsePublisher: AnyPublisher<LoadingState<[Animal]?>, Never>
        let citiesResponsePublihser:  AnyPublisher<LoadingState<[City]?>,   Never>
    }

    // MARK: - transform
    func transform(from input: Input) -> Output {

        // 1️⃣ 버튼 → Void trigger
        let animalTap = input.buttonTapped
            .filter { $0 == .animals }
            .map   { _ in () }                        // Void
            .eraseToAnyPublisher()

        let cityTap = input.buttonTapped
            .filter { $0 == .cities }
            .map   { _ in () }
            .eraseToAnyPublisher()

        // 2️⃣ trigger → API → LoadingState
        let animalsStream = animalTap.flatMapLatest {
            JsonService.shared.animals()
                .asApiEvent()
                .toLoadingState()
        }

        let citiesStream  = cityTap.flatMapLatest {
            JsonService.shared.cities()
                .asApiEvent()
                .toLoadingState()
        }

        // 3️⃣ next 버튼 → 코디네이터
        input.buttonTapped
            .filter { $0 == .next }
            .sink { [weak self] _ in self?.coordinatorEventSubject.send(.notice) }
            .store(in: &cancellables)

        return Output(
            coordinatorEvent: coordinatorEventSubject.eraseToAnyPublisher(),
            animalsResponsePublisher: animalsStream.eraseToAnyPublisher(),
            citiesResponsePublihser:  citiesStream.eraseToAnyPublisher()
        )
    }
}
