//
//  NoticeVM.swift
//  Unify
//
//  Created by Seojin on 4/25/25.
//

import SwiftUI
import Combine

final class NoticeVM: ObservableObject {
    @Published var title = "Hello SwiftUI"
    
    func updateTitle() {
        title = "Updated!"
    }
}
