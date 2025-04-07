//
//  Coordinator.swift
//  Unify
//
//  Created by Seojin on 4/7/25.
//



import UIKit
import Combine

// MARK: - Coordinator Protocol

/// 화면 전환 플로우를 관리하기 위한 기본 인터페이스입니다.
protocol Coordinator: AnyObject {
    /// 부모 코디네이터에게 자신이 완료되었음을 알리기 위한 델리게이트
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    
    /// 화면 전환 시 사용할 네비게이션 컨트롤러
    var navigationController: UINavigationController { get set }
    
    /// 자식 코디네이터들을 관리하기 위한 배열
    var childCoordinators: [Coordinator] { get set }
    
    static var coordinatorType: CoordinatorType { get }
    
    /// 코디네이터의 타입 (예: app, login, tab, launch)
    var type: CoordinatorType { get }
    
    /// Combine 구독 관리를 위한 AnyCancellable 집합
    var cancellables: Set<AnyCancellable> { get set }
    
    /// 플로우를 시작하는 메서드
    func start()
    
    /// 내부 바인딩 로직을 처리하는 메서드
    func binding()
    
    /// 플로우를 종료하고 정리하는 메서드
    func finish()
    
    /// 네비게이션 컨트롤러를 초기화하는 생성자
    init(_ navigationController: UINavigationController)
}

// MARK: - Coordinator Default Implementation

extension Coordinator {
    
    // 인스턴스 프로퍼티는 항상 클래스의 정적 프로퍼티를 반환하도록 함
    var type: CoordinatorType {
        return Self.coordinatorType
    }
    
    func finish() {
        // 자식 코디네이터들을 모두 제거
        childCoordinators.removeAll()
        // 부모에게 자신이 완료되었음을 알림
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

// MARK: - CoordinatorFinishDelegate Protocol

/// 자식 코디네이터가 완료되었음을 부모에게 알리기 위한 델리게이트 프로토콜
protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator?)
}

// MARK: - CoordinatorType

/// 애플리케이션의 플로우 유형을 구분하기 위한 열거형
enum CoordinatorType {
    case app
    case login
    case tab
    case intro
    case setting
}
