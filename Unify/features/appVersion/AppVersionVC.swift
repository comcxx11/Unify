//
//  AppVersionV.swift
//  Unify
//
//  Created by Seojin on 4/29/25.
//

import UIKit
import Combine


final class AppVersionVC: BaseViewStoryController<AppVersionVC.ButtonEvent> {
    
    enum ButtonEvent {
        case back
    }

    static let identifier: String = "AppVersionVC"
    
    // 🔥 ViewModel을 강하게 보관!
    private var _vm: AppVersionVM?
    
    private var vm: AppVersionVM {
        guard let vm = _vm else {
            fatalError("ViewModel must be injected before use.")
        }
        return vm
    }


    var didCoordinator: ((AppVersionVM.CoordinatorEvent) -> Void)?
    
    @MainActor required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func inject(
        vmProvider: @escaping () -> AppVersionVM,
        coordinator: Coordinator
    ) {
        // 💥 여기서 강한 참조로 ViewModel 저장
        let newVM = vmProvider()
        self._vm = newVM
        self.c = coordinator
        print("INJECT")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VEWDIDLOAD")
    }

    final class Assembler {
        let viewDidLoad: AnyPublisher<Void, Never>
        let buttonTapped: AnyPublisher<ButtonEvent, Never>
        
        init(vc: AppVersionVC) {
            self.viewDidLoad = vc.viewDidLoadSubject.eraseToAnyPublisher()
            self.buttonTapped = vc.buttonTappedSubject.eraseToAnyPublisher()
        }
        
        func makeInput() -> AppVersionVM.Input {
            return AppVersionVM.Input(
                viewDidLoad: viewDidLoad,
                buttonTapped: buttonTapped
            )
        }
    }
    
    override func bindVM() {
        
        let input = Assembler(vc: self).makeInput()
        let output = vm.transform(input: input)
        
        output.coordinator
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.didCoordinator?($0)
            }
            .store(in: &cancellables)
    }
    
    @IBAction func back(_ sender: Any) {
        buttonTappedSubject.send(.back)
    }
    
}
