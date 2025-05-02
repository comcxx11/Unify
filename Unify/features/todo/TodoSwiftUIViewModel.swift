//
//  TodoViewModel 2.swift
//  Unify
//
//  Created by seojin on 5/2/25.
//

import SwiftUI
import Combine

// ✅ SwiftUI에 바로 붙일 수 있는 ViewModel
final class TodoSwiftUIViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var todos: [Todo] = []
    @Published var isAddButtonEnabled: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        // 텍스트 변경 → 버튼 활성화 여부 계산
        $inputText
            .map { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            .removeDuplicates()
            .assign(to: &$isAddButtonEnabled)
    }

    func addTodo() {
        guard !inputText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let newTodo = Todo(title: inputText, isDone: false)
        todos.append(newTodo)
        inputText = ""
    }
}
