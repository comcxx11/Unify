//
//  BaseViewModel.swift
//  Unify
//
//  Created by Seojin on 4/7/25.
//

import Combine

protocol ViewModelable {
    associatedtype NavigationEvent
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

class BaseViewModel: ViewModelable {
    
    enum NavigationEvent { }
    
    struct Input { }
    
    struct Output { }
    
    var cancellables = Set<AnyCancellable>()
    
    func transform(input: Input) -> Output {
        Output()
    }
    
}
