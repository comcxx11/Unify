//  MainVM.swift
//  Unify
//
//  Created by Seojin on 4/24/25.
//

import Combine
import CombineExt
import Foundation

// MARK: - 타입 프로토콜
protocol MainVMType {
    func transform(from input: MainVM.Input) -> MainVM.Output
}

// MARK: - 뷰모델
final class MainVM: BaseViewModel<MainVM.CoordinatorEvent>, MainVMType {

    // ✨ 1. 의존성 주입용 프로퍼티
    private let service: JsonServiceProtocol          // ← 인터페이스 기반!

    // ✨ 2. DI 편의 생성자
    init(
        service: JsonServiceProtocol
    ) {
        self.service = service
        super.init()
    }

    // MARK: - 네비게이션 이벤트
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

        // 👉 JsonService.shared 대신 self.service 사용
        let animalsStream = input.buttonTapped
            .filter { $0 == .animals }
            .flatMapLatest { [weak self] _ -> AnyPublisher<LoadingState<[Animal]?>, Never> in
                guard let self = self else {
                    return Just(.idle).eraseToAnyPublisher()   // self가 없어지면 idle 방출 후 종료
                }
                return self.service.animals()
                    .asApiEvent()
                    .toLoadingState()
            }

        let citiesStream  = input.buttonTapped
            .filter { $0 == .cities }
            .flatMapLatest { [weak self] _ -> AnyPublisher<LoadingState<[City]?>, Never> in
                guard let self = self else {
                    return Just(.idle).eraseToAnyPublisher()   // self가 없어지면 idle 방출 후 종료
                }
                return self.service.cities()
                    .asApiEvent()
                    .toLoadingState()
            }

        input.buttonTapped
            .filter { $0 == .next }
            .sink { [weak self] _ in
                self?.coordinatorEventSubject.send(.notice)
            }
            .store(in: &cancellables)

        return Output(
            coordinatorEvent: coordinatorEventSubject.eraseToAnyPublisher(),
            animalsResponsePublisher: animalsStream.eraseToAnyPublisher(),
            citiesResponsePublihser:  citiesStream.eraseToAnyPublisher()
        )
    }
}
