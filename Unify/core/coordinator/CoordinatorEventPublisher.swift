//
//  CoordinatorEventPublisher.swift
//  Unify
//
//  Created by Seojin on 4/7/25.
//

import Combine
import UIKit

class CoordinatorEventPublisher {
    static let shared = CoordinatorEventPublisher()
    
    private init() { }
    
    let coordinatorSubject = PassthroughSubject<CoordinatorEvent, Never>()
    let tabbarSubject = PassthroughSubject<TabBarEvent, Never>()
}



