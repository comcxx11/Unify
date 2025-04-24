//
//  introView.swift
//  Unify
//
//  Created by Seojin on 4/7/25.
//

import UIKit
import SnapKit
import Combine

final class IntroV: BaseView {
    private let backgroundImageView = UIImageView()
    
    override func addSubviews() {
        addSubview(backgroundImageView)
    }
    
    override func configureSubviews() {
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        
        backgroundImageView.image = UIImage(named: "")
        self.backgroundColor = .red
    }
    
    override func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
