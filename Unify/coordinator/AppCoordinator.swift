//
//  AppCoordinator.swift
//  Unify
//
//  Created by Seojin on 4/7/25.
//

import UIKit
import Combine

protocol AppCoordinatorProtocol {
    func showIntroFlow()
    func showMainFlow()
}

final class AppCoordinator: Coordinator {
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
        
        binding()
    }
    
    var finishDelegate: (any CoordinatorFinishDelegate)?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [any Coordinator] = []
    
    static var coordinatorType: CoordinatorType = .app
    
    var cancellables = Set<AnyCancellable>()
    
    func start() {
        showIntroFlow()
    }
    
    func binding() {
        
    }
    
}

// MARK: - AppCoordinatorProtocol
extension AppCoordinator: AppCoordinatorProtocol {
    
    /// 인트로 플로우
    func showIntroFlow() {
        let introCoorinator = IntroCoordinator(navigationController)
        
        introCoorinator.finishDelegate = self
        introCoorinator.start()
        childCoordinators.append(introCoorinator)
    }
    
    /// 메인 플로우
    func showMainFlow() {
        print("MainFlow")
    }
    
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: (any Coordinator)?) {
        
        switch childCoordinator?.type {
        case .intro:
            navigationController.viewControllers.removeAll()
            showMainFlow()
        default:
            print("childCoordinator.type: \(childCoordinator?.type ?? .app)")
            fatalError("NO cooridnator terminator")
        }
    }
    
    
}
