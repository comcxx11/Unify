//
//  SettingVC.swift
//  Unify
//
//  Created by Seojin on 4/25/25.
//

import UIKit
import Combine

final class SettingVC: BaseViewController {
    private let v = SettingV()
    private let vm: SettingVMType
    
    init(vm: SettingVMType, c: Coordinator? = nil) {
        self.vm = vm
        super.init(c: c)
    }
    
    @MainActor required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = v
    }

    override func bindV() {
        
    }
    
    override func bindVM() {
        
        let input = SettingVM.Input(
            viewDidLoad: viewDidLoadSubject.eraseToAnyPublisher(),
            buttonTapped: v.buttonTappedSubject.eraseToAnyPublisher()
        )
        
        let output = vm.transform(from: input)
        
    }
}
