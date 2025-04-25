//
//  MainV.swift
//  Unify
//
//  Created by Seojin on 4/24/25.
//

import UIKit
import SnapKit

final class MainV: BaseView {
    
    enum ButtonEvent {
        
    }
    
    let title = UILabel().then {
        $0.text = "Hello"
    }
    
    override func addSubviews() {
        [title].forEach {
            addSubview($0)
        }
    }
    
    override func configureSubviews() {
        backgroundColor = .yellow
    }
    
    override func setupConstraints() {
        title.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
    }
}
