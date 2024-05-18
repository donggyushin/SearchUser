//
//  SceneDelegate.swift
//  App
//
//  Created by 신동규 on 5/17/24.
//

import UIKit
import Presentation
import DataLayer
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var requestAccessTokenTask: Task<(), any Error>? = nil
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        bind()
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = .init(windowScene: scene)
        return
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard requestAccessTokenTask == nil else { return }
        requestAccessTokenTask = Task {
            if let url = URLContexts.first?.url {
                let code = url.absoluteString.components(separatedBy: "code=").last ?? ""
                try? await DataLayer.AuthRepositoryImpl.shared.requestAccessToken(code: code)
                requestAccessTokenTask = nil 
            }
        }
    }
    
    private func bind() {
        DataLayer.AuthRepositoryImpl.shared
            .accessToken
            .receive(on: DispatchQueue.main)
            .sink { token in
                if token == nil {
                    if self.window?.rootViewController is Presentation.AuthViewController == false {
                        self.window?.rootViewController = 
                        Presentation.AuthViewController(
                            authRepository: AuthRepositoryImpl.shared
                        )
                    }
                } else {
                    if self.window?.rootViewController is Presentation.SearchUserViewController == false {
                        self.window?.rootViewController = 
                        Presentation.SearchUserViewController(
                            userRepository: UserRepositoryImpl.shared
                        )
                    }
                }
                
                self.window?.makeKeyAndVisible()
            }
            .store(in: &cancellables)
    }
}

