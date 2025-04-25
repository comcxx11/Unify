//
//  TabCoordinator.swift
//  Unify
//
//  Created by Seojin on 4/25/25.
//

import UIKit
import Combine

protocol TabCoordinatorProtocol: Coordinator {
    
}

final class TabCoordinator: NSObject, TabCoordinatorProtocol {
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        self.tabBarController = UITabBarController()
    }
    
    static var coordinatorType: CoordinatorType = .tab
    
    var finishDelegate: (any CoordinatorFinishDelegate)?
    
    var navigationController: UINavigationController
    
    // 추가됨
    var tabBarController: UITabBarController
    
    var childCoordinators: [any Coordinator] = []
    
    var cancellables: Set<AnyCancellable> = []
    
    func start() {
        let pages: [Tab] = [.home, .setting].sorted(by: {
            $0.pageOrder < $1.pageOrder
        })
        
        let controllers: [UINavigationController] = pages.map({
            getTabController($0)
        })
        
        prepareTabBarController(withTabControllers: controllers)
    }
    
    func binding() {
        
    }

}

extension TabCoordinator {
    private func getTabController(_ page: Tab) -> UINavigationController {
        let nav = UINavigationController()
        
        nav.setNavigationBarHidden(true, animated: false)
        
        nav.tabBarItem = UITabBarItem(title: page.title, image: UIImage(named: page.imageName), tag: page.pageOrder)
        
        switch page {
        case .home:
            let c = MainCoordinator(nav)
            c.finishDelegate = finishDelegate
            c.start()
            childCoordinators.append(c)
        case .setting:
            break
        }
        
        return nav
    }
    
    private func prepareTabBarController(withTabControllers tabControllers: [UINavigationController]) {
        tabBarController.delegate = self
        tabBarController.setViewControllers(tabControllers, animated: false)
        tabBarController.selectedIndex = Tab.home.pageOrder
        tabBarController.tabBar.isTranslucent = false
        
        navigationController.viewControllers = [tabBarController]
    }
}

extension TabCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // 이미 선택된 탭을 다시 탭한 경우
        if tabBarController.selectedViewController == viewController {
            // 탭 아이템의 tag를 이용해 Plus 탭인지 확인 (TabBarPage.plus.pageOrderNumber와 비교)
            if viewController.tabBarItem.tag == Tab.setting.pageOrder {
                // Plus 탭에서 재선택 시 아무런 동작도 하지 않도록 false 반환
                return false
            }
        }
        return true
    }
}
