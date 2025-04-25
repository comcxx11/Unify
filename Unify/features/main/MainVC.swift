//
//  MainVC.swift
//  Unify
//
//  Created by Seojin on 4/25/25.
//

import UIKit
import Combine

final class MainVC: BaseViewController {
    private let v = MainV()
    private let vm: MainVMType
    
    init(vm: MainVMType, c: Coordinator? = nil) {
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
        
    }
}
