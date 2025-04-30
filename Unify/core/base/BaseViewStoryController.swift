//
//  BaseViewController.swift
//  Unify
//
//  Created by Seojin on 4/7/25.
//

import UIKit
import Combine

class BaseViewStoryController<Event>: UIViewController, BaseViewControllerProtocol {
    
    enum ButtonEvent { }
    
    var c: Coordinator?
    
    var cancellables: Set<AnyCancellable> = []
    
    let buttonTappedSubject = PassthroughSubject<Event, Never>()
    
    let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    
    deinit {
        print("[Deinit] \(type(of: self)) released")
    }
    
    override func viewDidLoad() {
        
        print("viewDidLoad super")
        
        // 1) View와의 이벤트 바인딩
        bindV()
        
        // 2) ViewModel 바인딩
        bindVM()
        
        viewDidLoadSubject.send(())
    }
    
    func bindV() { }
    
    func bindVM() { }
    
}
