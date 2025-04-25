//
//  BaseViewModel.swift
//  Unify
//
//  Created by Seojin on 4/7/25.
//

import Combine

protocol ViewModelable {
    associatedtype CoordinatorEvent
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

class BaseViewModel<Event>: ViewModelable {
    
    enum CoordinatorEvent { }
    
    struct Input { }
    
    struct Output { }
    
    var cancellables = Set<AnyCancellable>()
    
    let coordinatorEventSubject = PassthroughSubject<Event, Never>()
    
    func transform(input: Input) -> Output {
        Output()
    }
    
}
