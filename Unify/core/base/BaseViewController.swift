//
//  BaseViewController.swift
//  Unify
//
//  Created by Seojin on 4/7/25.
//

import UIKit
import Combine

@objc protocol BaseViewControllerProtocol {
    func bindView()
    func bindViewModel()
}

class BaseViewController: UIViewController, BaseViewControllerProtocol {
    
    var c: Coordinator?
    
    var cancellables: Set<AnyCancellable> = []
    
    let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    
    init(c: Coordinator? = nil) {
        self.c = c
        super.init(nibName: nil, bundle: nil)
    }
    
    // 스토리보드로 뷰컨 만들지 않기
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("[Deinit] \(type(of: self)) released")
    }
    
    override func viewDidLoad() {
        // 1) View와의 이벤트 바인딩
        bindView()
        
        // 2) ViewModel 바인딩
        bindViewModel()
        
        viewDidLoadSubject.send(())
    }
    
    func bindView() { }
    
    func bindViewModel() { }
    
}

extension BaseViewController: UIGestureRecognizerDelegate {
    // 커스텀 네비게이션에 스와이프 백 허용
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}

extension UIViewController {
    // 커스텀 네비게이션에 스와이프 백 허용
    func enableSwipeBack() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}
