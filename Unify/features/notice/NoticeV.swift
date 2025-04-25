//
//  NoticeV.swift
//  Unify
//
//  Created by Seojin on 4/25/25.
//

import SwiftUI

struct NoticeV: View {
    
    @ObservedObject var vm: NoticeVM
    
    var body: some View {
        VStack {
            Text(vm.title)
            Button("Update") {
                vm.updateTitle()
            }
        }
        .padding()
    }
}
