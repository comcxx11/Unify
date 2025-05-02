//
//  ConfirmButton.swift
//  Unify
//
//  Created by Seojin on 5/2/25.
//

import UIKit

enum ConfirmButtonStyle {
    case filled
    case outlined
    case disabled
}

final class ConfirmButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setStyle(.filled)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        setStyle(.filled)
    }
    
    private func configureUI() {
        self.layer.cornerRadius = 24
        
        // self.contentEdgeInsets = UIEdgeInsets(top: 16, left: 32, bottom: 16, right: 32)

        self.clipsToBounds = true

        // self.titleLabel?.setPretendardFont(style: .medium, size: 16)
    }
    
    func setStyle(_ style: ConfirmButtonStyle) {
        
        self.isUserInteractionEnabled = true
        
        switch style {
        case .filled:
            // self.backgroundColor = .x005498
            self.backgroundColor = .red
            self.setTitleColor(.white, for: .normal)
            self.layer.borderWidth = 0
            self.layer.borderColor = nil
            self.isUserInteractionEnabled = true
        case .outlined:
            self.backgroundColor = .white
            self.setTitleColor(.red, for: .normal)
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.red.cgColor
            self.isUserInteractionEnabled = true
        case .disabled:
            self.backgroundColor = .gray
            self.setTitleColor(.white, for: .normal)
            self.layer.borderWidth = 0
            self.layer.borderColor = nil
            
            self.isUserInteractionEnabled = false
        }
    }
    
    func setButtonTitle(_ title: String) {
        self.setTitle(title, for: .normal)
    }
}
