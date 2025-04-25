//
//  MainCoordinator.swift
//  Unify
//
//  Created by Seojin on 4/25/25.
//

import UIKit
import Combine
import SwiftUI

protocol WalletCordinatorProtocoal: Coordinator {
    
}


final class MainCoordinator: WalletCordinatorProtocoal {
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    var finishDelegate: (any CoordinatorFinishDelegate)?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [any Coordinator] = []
    
    static var coordinatorType: CoordinatorType = .main
    
    var cancellables: Set<AnyCancellable> = []
    
    func start() {
        let vc = MainVC(vm: MainVM(), c: self)
        vc.didCoordinator = { [weak self] in
            switch $0 {
            case .next:
                self?.finish()
            case .notice:
                self?.showNotice()
            }
        }
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func binding() {
        
    }
    
    func showNotice() {
        let vm = NoticeVM()
        let v = NoticeV(vm: vm)
        let vc = UIHostingController(rootView: v)
        
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    
}
