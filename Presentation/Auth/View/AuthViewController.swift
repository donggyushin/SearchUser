//
//  AuthViewController.swift
//  Presentation
//
//  Created by 신동규 on 5/18/24.
//

import UIKit
import Then
import SnapKit
import MockData
import Domain

public final class AuthViewController: UIViewController {
    
    private let requestGithubCodeUsecase: RequestGithubCodeUsecase
    
    private lazy var githubLoginButton = UIButton(configuration: .borderedTinted(), primaryAction: UIAction(handler: { [weak self] _ in
        self?.requestGithubCodeUsecase.implement()
    }))
        .then { button in
            button.setTitle("Sign in with Github", for: .normal)
        }
    
    public init(authRepository: AuthRepository) {
        requestGithubCodeUsecase = .init(authRepository: authRepository)
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
        view.addSubview(githubLoginButton)
        githubLoginButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

#Preview {
    let vc = AuthViewController(authRepository: AuthRepositoryImpl())
    return vc
}
