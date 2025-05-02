//
//  TodoViewModel.swift
//  Unify
//
//  Created by seojin on 5/2/25.
//


import Combine
import Foundation

struct Todo: Identifiable {
  var id: UUID = UUID()
  let title: String
  let isDone: Bool
}

final class TodoViewModel {
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let textChanged: AnyPublisher<String, Never>
        let addButtonTapped: AnyPublisher<Void, Never>
    }

    struct Output {
        let todos: AnyPublisher<[Todo], Never>
        let isAddButtonEnabled: AnyPublisher<Bool, Never>
    }

    private let todos = CurrentValueSubject<[Todo], Never>([])
    private let currentText = CurrentValueSubject<String, Never>("")
    private var cancellables = Set<AnyCancellable>()

    func transform(input: Input) -> Output {
        input.textChanged
            .sink { [weak self] in self?.currentText.send($0) }
            .store(in: &cancellables)

        input.addButtonTapped
            .withLatestFrom(currentText)
            .map { Todo(title: $0, isDone: false) }
            .sink { [weak self] newTodo in
                self?.todos.value.append(newTodo)
                self?.currentText.send("")
            }
            .store(in: &cancellables)

        let isAddEnabled = currentText
            .map { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            .removeDuplicates()
            .eraseToAnyPublisher()

        return Output(todos: todos.eraseToAnyPublisher(),
                      isAddButtonEnabled: isAddEnabled)
    }
}
