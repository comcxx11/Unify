//
//  LoadingManager.swift
//  Unify
//
//  Created by Seojin on 5/2/25.
//



import Foundation
import Combine

final class LoadingManager: ObservableObject {
    static let shared = LoadingManager()
    
    @Published private(set) var isLoading: Bool = false
    private var counter: Int = 0
    private let lock = NSLock()
    
    private init() {}
    
    func increment() {
        lock.lock()
        counter += 1
        updateState()
        lock.unlock()
    }
    
    func decrement() {
        lock.lock()
        counter = max(counter - 1, 0)
        updateState()
        lock.unlock()
    }
    
    private func updateState() {
        isLoading = counter > 0
    }
}
