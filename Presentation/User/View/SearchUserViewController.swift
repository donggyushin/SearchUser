//
//  SearchUserViewController.swift
//  Presentation
//
//  Created by 신동규 on 5/17/24.
//

import UIKit
import Domain
import MockData
import Combine

public final class SearchUserViewController: UIViewController {
    private let viewModel: SearchUserViewModel
    
    private let textField = SearchUserTextField()
    private lazy var tableView = UITableView()
        .then { tableView in
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(SearchUserCell.self, forCellReuseIdentifier: SearchUserCell.identifier)
        }
    
    private var cancellables = Set<AnyCancellable>()
    public init(userRepository: UserRepository) {
        viewModel = .init(userRepository: userRepository)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        bind()
    }
    
    private func bind() {
        viewModel
            .$users
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        textField
            .text
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.viewModel.query = text
            }
            .store(in: &cancellables)
        
        textField
            .search
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.viewModel.search()
            }
            .store(in: &cancellables)
    }
    
    private func configUI() {
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

extension SearchUserViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.users.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchUserCell.identifier) as? SearchUserCell ?? SearchUserCell()
        let user = viewModel.users[indexPath.row]
        cell.configUI(user: user)
        return cell
    }
}

extension SearchUserViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.users[indexPath.row]
        guard let url = URL(string: data.url) else { return }
        UIApplication.shared.open(url)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

#Preview {
    let vc = SearchUserViewController(userRepository: UserRepositoryImpl())
    return vc
}
