//
//  TodoViewController.swift
//  Unify
//
//  Created by seojin on 5/2/25.
//

import UIKit
import Combine

final class TodoViewController: UIViewController {
    private let viewModel = TodoViewModel()

    private let inputTextField = UITextField()
    private let addButton = UIButton(type: .system)
    private let tableView = UITableView()

    private var cancellables = Set<AnyCancellable>()
    private let textChangedSubject = PassthroughSubject<String, Never>()
    private let addButtonTappedSubject = PassthroughSubject<Void, Never>()

    private var todoList: [Todo] = [] {
        didSet { tableView.reloadData() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.view.backgroundColor = .systemBackground

        setupUI()

        let input = TodoViewModel.Input(
            viewDidLoad: Just(()).eraseToAnyPublisher(),
            textChanged: textChangedSubject.eraseToAnyPublisher(),
            addButtonTapped: addButtonTappedSubject.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        output.todos
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.todoList = $0 }
            .store(in: &cancellables)

        output.isAddButtonEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.addButton.isEnabled = $0 }
            .store(in: &cancellables)
    }

  private func setupUI() {
      view.addSubview(inputTextField)
      view.addSubview(addButton)
      view.addSubview(tableView)

      inputTextField.borderStyle = .roundedRect
      addButton.setTitle("추가", for: .normal)

      inputTextField.translatesAutoresizingMaskIntoConstraints = false
      addButton.translatesAutoresizingMaskIntoConstraints = false
      tableView.translatesAutoresizingMaskIntoConstraints = false

      NSLayoutConstraint.activate([
          inputTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
          inputTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
          inputTextField.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -10),

          addButton.centerYAnchor.constraint(equalTo: inputTextField.centerYAnchor),
          addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

          tableView.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 20),
          tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])

      tableView.dataSource = self
    
    // 텍스트 필드, 버튼, 테이블뷰 UI 세팅
    inputTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
  
  }

  
    @objc private func textChanged() {
        textChangedSubject.send(inputTextField.text ?? "")
    }

    @objc private func addButtonTapped() {
        addButtonTappedSubject.send(())
    }
}

extension TodoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell") ?? UITableViewCell(style: .default, reuseIdentifier: "TodoCell")
        cell.textLabel?.text = todoList[indexPath.row].title
        return cell
    }
}
