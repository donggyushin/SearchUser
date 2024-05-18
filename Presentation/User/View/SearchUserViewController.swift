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
    private let logoutUsecase: LogoutUsecase
    
    private let textField = SearchUserTextField()
    private lazy var tableView = UITableView()
        .then { tableView in
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(SearchUserCell.self, forCellReuseIdentifier: SearchUserCell.identifier)
        }
    private lazy var searchUserEmptyListView = SearchUserEmptyListView()
    
    private let loadingView = UIActivityIndicatorView(style: .large)
    
    private var cancellables = Set<AnyCancellable>()
    public init(
        userRepository: UserRepository,
        authRepository: AuthRepository
    ) {
        viewModel = .init(userRepository: userRepository)
        logoutUsecase = .init(authRepository: authRepository)
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
            .sink { [weak self] users in
                self?.tableView.reloadData()
                self?.searchUserEmptyListView.isHidden = !users.isEmpty
                self?.tableView.isHidden = users.isEmpty
            }
            .store(in: &cancellables)
        
        viewModel
            .$loading
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loading in
                loading ?
                self?.loadingView.startAnimating() :
                self?.loadingView.stopAnimating()
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
        
        view.addSubview(searchUserEmptyListView)
        searchUserEmptyListView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(40)
        }
        
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func presentErrorAlert(message: String) {
        let alert: UIAlertController = .init(
            title: "Error Occured",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(.init(title: "Ok", style: .default, handler: { [weak self] _ in
            self?.logoutUsecase.implement()
        }))
        self.present(alert, animated: true)
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
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.users.count - 1 {
            viewModel.loadMoreUsers()
        }
    }
}

#Preview {
    let vc = SearchUserViewController(
        userRepository: UserRepositoryImpl(),
        authRepository: AuthRepositoryImpl())
    return vc
}
