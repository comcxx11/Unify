//
//  MainVM.swift
//  Unify
//
//  Created by Seojin on 4/24/25.
//

import Combine

final class MainVM: BaseViewModel {
    
    enum CoordinatorEvent {
        case launch
    }
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let buttonTapped: AnyPublisher<MainV.ButtonEvent, Never>
    }
    
    struct Output {
        
    }
    
    override init() {
        
    }
    
    private let navigationSubject = PassthroughSubject<CoordinatorEvent, Never>()
    
    func transform(input: Input) -> Output {
        Output()
    }
}
