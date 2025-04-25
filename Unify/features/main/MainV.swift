//
//  MainV.swift
//  Unify
//
//  Created by Seojin on 4/24/25.
//

import UIKit
import SnapKit

final class MainV: BaseView<MainV.ButtonEvent> {
    
    enum ButtonEvent {
        case next
    }
    
    let button = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .blue
    }
    
    override func addSubviews() {
        [button].forEach {
            addSubview($0)
        }
    }
    
    override func configureSubviews() {
        backgroundColor = .yellow
    }
    
    override func setupConstraints() {
        
        button.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
    }
    
    override func setupEvents() {
        button
            .bindTap(to: buttonTappedSubject, event: .next)
            .store(in: &cancellables)
    }
}
