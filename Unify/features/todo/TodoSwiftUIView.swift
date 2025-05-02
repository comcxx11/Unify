//
//  TodoSwiftUIView.swift
//  Unify
//
//  Created by seojin on 5/2/25.
//

import SwiftUI
import Combine

struct TodoSwiftUIView: View {
  // @StateObject private var wrapper = TodoViewModelWrapper()
  @StateObject private var vm = TodoSwiftUIViewModel()
  
  var body: some View {
    VStack {
      TextField("할 일을 입력하세요", text: $vm.inputText)
        .textFieldStyle(RoundedBorderTextFieldStyle())
      
      Button("추가하기") {
        // wrapper.addButtonTapped.send(())
        vm.addTodo()
      }
      .disabled(!vm.isAddButtonEnabled)
      
      List(vm.todos) { todo in
        Text(todo.title)
      }
    }
    .padding()
  }
}
