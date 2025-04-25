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

final class MainVM: MainVMType {
    
    enum CoordinatorEvent {
        case launch
    }
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let buttonTapped: AnyPublisher<MainV.ButtonEvent, Never>
    }
    
    struct Output {
        
    }
    
    private let navigationSubject = PassthroughSubject<CoordinatorEvent, Never>()
    
    func transform(from input: Input) -> Output {
        Output()
    }
}
