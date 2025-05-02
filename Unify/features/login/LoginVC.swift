//
//  IntroVC.swift
//  Unify
//
//  Created by Seojin on 5/2/25.
//


import UIKit
import Combine

final class LoginVC: BaseViewController {
    
    private let v = LoginV()
    private let vm: LoginVMType
    
    var didCoordinator: ((LoginVM.CoordinatorEvent) -> Void)?
    
    init(vm: LoginVM, c: Coordinator? = nil) {
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
        
        let input = LoginVM.Input(
            viewDidLoad: viewDidLoadSubject.eraseToAnyPublisher(),
            buttonTapped: v.buttonTappedSubject.eraseToAnyPublisher()
        )
        
        let output = vm.transform(from: input)
        
        output.coordinator
            .sink { [weak self] event in
                switch event {
                case .login:
                    // self?.c?.finish()
                    self?.didCoordinator?(.login)
                }
            }
            .store(in: &cancellables)
        
        
    }
}
