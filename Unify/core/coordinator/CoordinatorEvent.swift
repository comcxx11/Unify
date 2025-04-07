//
//  CoordinatorEvent.swift
//  Unify
//
//  Created by Seojin on 4/7/25.
//

import UIKit

enum CoordinatorEvent {
    case loadMain
    case pushCoordinator(coordinator: Any?, animated: Bool, completion: (() -> Void)? = nil)
    case popCoordinator(animated: Bool, completion: (() -> Void)? = nil)
    case removeCoordinator
    case push(_ viewController: UIViewController?, animated: Bool)
    case present(_ viewController: UIViewController?, animated: Bool, completion: (() -> Void)? = nil)
    case dismiss(_ viewController: UIViewController?, animated: Bool, completion: (() -> Void)? = nil)
    
    case popToMain(animated: Bool = true, completion: (() -> Void)? = nil)
    case popToRoot(animated: Bool = true, completion: (() -> Void)? = nil)
    case pushNotice(animated: Bool = true)
    case pushWebViewController(url: URL, animated: Bool)
    case presentWebViewController(url: URL, animated: Bool, completion: (() -> Void)? = nil)
}
