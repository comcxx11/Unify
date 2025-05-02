//
//  MainV.swift
//  Unify
//
//  Created by Seojin on 4/24/25.
//

import UIKit
import SnapKit
import Combine

final class MainV: BaseView<MainV.ButtonEvent> {

    enum ButtonEvent {
        case next
        case animals
        case cities
    }

    struct MenuItem: Hashable {
        let title: String
        let event: ButtonEvent
    }

    private let items: [MenuItem] = [
        .init(title: "ANIMAL", event: .animals),
        .init(title: "CITY", event: .cities),
        .init(title: "다음", event: .next)
    ]

    private let tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.rowHeight = 60
        $0.backgroundColor = .clear
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private let loadingView = UIVisualEffectView(effect: UIBlurEffect(style: .light)).then {
        $0.isHidden = true
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true

        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .darkGray
        indicator.startAnimating()
        $0.contentView.addSubview(indicator)

        indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    override func addSubviews() {
        addSubview(tableView)
        addSubview(loadingView)
    }

    override func configureSubviews() {
        backgroundColor = .yellow
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        
        
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func showLoading(_ isLoading: Bool) {
        loadingView.isHidden = !isLoading
    }
}

extension MainV: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var config = UIListContentConfiguration.cell()
        config.text = item.title
        config.textProperties.color = .white
        cell.contentConfiguration = config
        cell.backgroundColor = .blue
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = items[indexPath.row].event
        buttonTappedSubject.send(event)
    }

}
