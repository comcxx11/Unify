//
//  Tab.swift
//  Unify
//
//  Created by Seojin on 4/25/25.
//

import Foundation

enum Tab {
    case home
    case setting
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .home
        case 1:
            self = .setting
        default:
            return nil
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "홈"
        case .setting:
            return "설정"
        }
    }
    
    var pageOrder: Int {
        switch self {
        case .home:
            return 0
        case .setting:
            return 1
        }
    }
    
    var imageName: String {
        switch self {
        case .home:
            return "icon_tab_home"
        case .setting:
            return "icon_tab_setting"
        }
    }
}
