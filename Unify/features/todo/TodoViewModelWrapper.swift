//
//  TodoViewModelWrapper.swift
//  Unify
//
//  Created by seojin on 5/2/25.
//

import Combine
import SwiftUI

final class TodoViewModelWrapper: ObservableObject {
    @Published var inputText = ""
    @Published var todos: [Todo] = []
    @Published var isAddButtonEnabled = false

    let addButtonTapped = PassthroughSubject<Void, Never>()

    private let viewModel = TodoViewModel()
    private var cancellables = Set<AnyCancellable>()

    init() {
        let input = TodoViewModel.Input(
            viewDidLoad: Just(()).eraseToAnyPublisher(),
            textChanged: $inputText.eraseToAnyPublisher(),
            addButtonTapped: addButtonTapped.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        output.todos
            .receive(on: RunLoop.main)
            .assign(to: &$todos)

        output.isAddButtonEnabled
            .receive(on: RunLoop.main)
            .assign(to: &$isAddButtonEnabled)
    }
}
