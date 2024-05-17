//
//  SceneDelegate.swift
//  App
//
//  Created by 신동규 on 5/17/24.
//

import UIKit
import Presentation
import DataLayer

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var requestAccessTokenTask: Task<(), any Error>? = nil

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = .init(windowScene: scene)
        window?.rootViewController = Presentation.SearchUserViewController()
        window?.makeKeyAndVisible()
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
}

