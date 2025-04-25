//
//  IntroVC.swift
//  Unify
//
//  Created by Seojin on 4/7/25.
//

import UIKit
import Combine

final class IntroVC: BaseViewController {
    
    private let v = IntroV()
    private let vm: IntroVM
    
    var didCoordinator: ((IntroVM.CoordinatorEvent) -> Void)?
    
    init(vm: IntroVM, c: Coordinator? = nil) {
        self.vm = vm
        super.init(c: c)
    }
    
    @MainActor required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bindV() {
        view = v
    }
    
    override func bindVM() {
        
        let input = IntroVM.Input(
            viewDidLoad: viewDidLoadSubject.eraseToAnyPublisher()
        )
        
        let output = vm.transform(input: input)
        
        output.coordinator
            .sink { [weak self] event in
                switch event {
                case .launch:
                    self?.c?.finish()
                }
            }
            .store(in: &cancellables)
        
        
    }
}
