//
//  BaseView.swift
//  Unify
//
//  Created by Seojin on 4/7/25.
//

import UIKit
import Combine

protocol ViewBuildable {
    func addSubviews()
    func configureSubviews()
    func setupConstraints()
}

class BaseView<Event>: UIView, ViewBuildable {
    
    enum ButtonEvent {
        
    }
    
    let buttonTappedSubject = PassthroughSubject<Event, Never>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubviews()
        configureSubviews()
        setupConstraints()
    }

    func addSubviews() {
        
    }
    
    func configureSubviews() {
        
    }
    
    func setupConstraints() {
        
    }

}
