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
    
    var cancellables: Set<AnyCancellable> = []
    
    let buttonTappedSubject = PassthroughSubject<Event, Never>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configureSubviews()
        setupConstraints()
        setupEvents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        
    }
    
    func configureSubviews() {
        
    }
    
    func setupConstraints() {
        
    }
    
    func setupEvents() {
        
    }

}
