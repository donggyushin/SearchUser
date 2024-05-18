//
//  AuthViewController.swift
//  Presentation
//
//  Created by 신동규 on 5/18/24.
//

import UIKit
import Then
import SnapKit

public final class AuthViewController: UIViewController {
    
    private lazy var githubLoginButton = UIButton(configuration: .borderedTinted(), primaryAction: UIAction(handler: { _ in
        print("tap button")
    }))
        .then { button in
            button.setTitle("Sign in with Github", for: .normal)
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
    let vc = AuthViewController()
    return vc
}
