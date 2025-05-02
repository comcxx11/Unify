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
        let vc = MainVC(vm: MainVM(service: JsonService()), c: self)
        vc.didCoordinator = { [weak self] in
            switch $0 {
            case .next:
                self?.finish()
            case .notice:
                // self?.showNotice()
                // self?.showAppVersion()
                self?.showLogin()
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
    
    func showLogin() {
        let vm = LoginVM()
        let vc = LoginVC(vm: vm)
        vc.didCoordinator = { [weak self] in
            switch $0 {
            case .login:
                self?.navigationController.popViewController(animated: true)
            }
        }
        
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showAppVersion() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: AppVersionVC.identifier) as! AppVersionVC
        vc.inject(vmProvider: {
            AppVersionVM()
        }, coordinator: self)
        vc.didCoordinator = { [weak self] in
            switch $0 {
            case .back:
                self?.navigationController.popViewController(animated: true)
            }
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
}
