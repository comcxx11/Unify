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
    
    init(vm: IntroVM, c: Coordinator? = nil) {
        self.vm = vm
        super.init(c: c)
    }
    
    @MainActor required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bindView() {
        view = v
    }
    
    override func bindViewModel() {
        
    }
}
