//
//  MainCoordinator.swift
//  Unify
//
//  Created by Seojin on 4/25/25.
//

import UIKit
import Combine

protocol SettingCordinatorProtocoal: Coordinator {
    
}


final class SettingCoordinator: SettingCordinatorProtocoal {
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    var finishDelegate: (any CoordinatorFinishDelegate)?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [any Coordinator] = []
    
    static var coordinatorType: CoordinatorType = .main
    
    var cancellables: Set<AnyCancellable> = []
    
    func start() {
        let vc = SettingVC(vm: SettingVM(), c: self)
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func binding() {
        
    }
    
    
}
