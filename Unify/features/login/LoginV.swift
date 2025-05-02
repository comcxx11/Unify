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
        case back
    }
    
    let button = ConfirmButton().then {
        $0.titleLabel?.text = "Login"
    }
    
    override func addSubviews() {
        [button].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        button.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().offset(20)
        }
    }
    
}
