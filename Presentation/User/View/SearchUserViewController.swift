//
//  SearchUserViewController.swift
//  Presentation
//
//  Created by 신동규 on 5/17/24.
//

import UIKit
import Domain
import MockData

public final class SearchUserViewController: UIViewController {
    private let viewModel: SearchUserViewModel
    
    private let textField = SearchUserTextField()
    
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
    }
    
    private func configUI() {
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
    }
}

#Preview {
    let vc = SearchUserViewController(userRepository: UserRepositoryImpl())
    return vc
}
