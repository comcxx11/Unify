//
//  TabBarEvent.swift
//  Unify
//
//  Created by Seojin on 4/7/25.
//


enum TabBarEvent {
    case select
    case deselect
    case isHidden(_ hidden: Bool, animated: Bool = true)
}
