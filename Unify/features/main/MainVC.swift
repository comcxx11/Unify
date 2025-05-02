//
//  MainVC.swift
//  Unify
//
//  Created by Seojin on 4/25/25.
//

import UIKit
import Combine




final class MainVC: BaseViewController {
    
    private let v = MainV()
    private let vm: MainVMType
    
    var didCoordinator: ((MainVM.CoordinatorEvent) -> Void)?
    
    init(vm: MainVMType, c: Coordinator? = nil) {
        self.vm = vm
        super.init(c: c)
    }
    
    final class Assembler {
        let viewDidLoad: AnyPublisher<Void, Never>
        let buttonTapped: AnyPublisher<MainV.ButtonEvent, Never>
        
        init(v: MainV, vc: MainVC) {
            self.viewDidLoad = vc.viewDidLoadSubject.eraseToAnyPublisher()
            self.buttonTapped = v.buttonTappedSubject.eraseToAnyPublisher()
        }
        
        func makeInput() -> MainVM.Input {
            return MainVM.Input(
                viewDidLoad: viewDidLoad,
                buttonTapped: buttonTapped
            )
        }
    }
    
    @MainActor required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = v
    }

    override func bindV() {
        
    }
    
    override func bindVM() {
        
        let input = Assembler(v: v, vc: self).makeInput()
        let output = vm.transform(from: input)
        
        output.coordinatorEvent
            .receive(on: RunLoop.main)
            .sink {
                self.didCoordinator?($0)
            }
            .store(in: &cancellables)
        
        output.animalsResponsePubliser
            .receive(on: RunLoop.main)
            .sink {
                print("❤️ \($0)")
            }
            .store(in: &cancellables)
        
        output.citiesResponsePubliser
            .receive(on: RunLoop.main)
            .sink { completion in
                print(completion)
            } receiveValue: {
                print("❤️ \($0 ?? [])")
            }
            .store(in: &cancellables)

    }
}
