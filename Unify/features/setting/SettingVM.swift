//
//  SettingVM.swift
//  Unify
//
//  Created by Seojin on 4/25/25.
//


import Combine


protocol SettingVMType {
    func transform(from input: SettingVM.Input) -> SettingVM.Output
}

final class SettingVM: SettingVMType {
    
    enum CoordinatorEvent {
        case launch
    }
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let buttonTapped: AnyPublisher<SettingV.ButtonEvent, Never>
    }
    
    struct Output {
        
    }
    
    private let navigationSubject = PassthroughSubject<CoordinatorEvent, Never>()
    
    func transform(from input: Input) -> Output {
        Output()
    }
}
