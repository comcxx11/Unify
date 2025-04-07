//
//  IntroCoordinator.swift
//  Unify
//
//  Created by Seojin on 4/7/25.
//

import UIKit
import Combine

final class IntroCoordinator: Coordinator {
    
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var finishDelegate: (any CoordinatorFinishDelegate)?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [any Coordinator] = []
    
    static var coordinatorType: CoordinatorType = .intro
    
    var cancellables: Set<AnyCancellable> = []
    
    func start() {
        
    }
    
    func binding() {
        
    }
    
}
