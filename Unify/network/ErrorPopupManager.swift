//
//  ErrorPopupManager.swift
//  Unify
//
//  Created by Seojin on 5/2/25.
//



import UIKit

final class ErrorPopupManager {
    static let shared = ErrorPopupManager()
    
    private init() {}
    
    /// 현재 최상위 뷰 컨트롤러를 찾아 반환
    private func topViewController(from viewController: UIViewController?) -> UIViewController? {
        if let navigation = viewController as? UINavigationController {
            return topViewController(from: navigation.visibleViewController)
        } else if let tab = viewController as? UITabBarController {
            return topViewController(from: tab.selectedViewController)
        } else if let presented = viewController?.presentedViewController {
            return topViewController(from: presented)
        }
        return viewController
    }
    
    /// 에러 팝업을 표시하는 메서드
    func showError(_ error: Error) {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
                  let topVC = self.topViewController(from: window.rootViewController) else { return }
            
            let alert = UIAlertController(title: "에러 발생", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            topVC.present(alert, animated: true, completion: nil)
        }
    }
}
