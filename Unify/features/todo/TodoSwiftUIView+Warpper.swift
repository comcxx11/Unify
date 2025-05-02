//
//  TodoSwiftUIView 2.swift
//  Unify
//
//  Created by seojin on 5/2/25.
//


import SwiftUI
import Combine

struct TodoSwiftUIViewWrapper: View {
  @StateObject private var wrapper = TodoViewModelWrapper()
  
  var body: some View {
    VStack {
      TextField("할 일을 입력하세요", text: $wrapper.inputText)
        .textFieldStyle(RoundedBorderTextFieldStyle())
      
      Button("추가하기") {
        wrapper.addButtonTapped.send(())
      }
      .disabled(!wrapper.isAddButtonEnabled)
      
      List(wrapper.todos) { todo in
        Text(todo.title)
      }
    }
    .padding()
  }
}
