//
//  MainCoordinator.swift
//  Unify
//
//  Created by Seojin on 4/25/25.
//

import UIKit
import Combine

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
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func binding() {
        
    }
    
    
}
