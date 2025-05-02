//
//  LoginV.swift
//  Unify
//
//  Created by Seojin on 5/2/25.
//

import UIKit
import SnapKit
import Combine

final class LoginV: BaseView<LoginV.ButtonEvent> {
    
    enum ButtonEvent {
        case login
    }
    
    let button = ConfirmButton().then {
        $0.setButtonTitle("로그인")
    }
    
    override func addSubviews() {
        [button].forEach {
            addSubview($0)
        }
    }
    
    override func configureSubviews() {
        self.backgroundColor = .white
    }
    
    override func setupConstraints() {
        button.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }
    }
    
    override func setupEvents() {
        button
            .bindTap(to: buttonTappedSubject, event: .login)
            .store(in: &cancellables)
    }
    
}
