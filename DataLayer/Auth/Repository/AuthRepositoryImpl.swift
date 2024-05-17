//
//  AuthRepositoryImpl.swift
//  DataLayer
//
//  Created by 신동규 on 5/17/24.
//

import Foundation
import UIKit
import Moya

public final class AuthRepositoryImpl {
    public static let shared = AuthRepositoryImpl()
    
    @Published var accessToken: String? = nil
    
    private let clientID = "Ov23ctO8MVeCSW1Otcnb"
    
    private init() { }
    
    public func requestCode() {
        let urlString = "https://github.com/login/oauth/authorize?client_id=\(clientID)"
        guard let url: URL = .init(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    public func requestAccessToken(code: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let provider = MoyaProvider<Github>()
            provider.request(.token(code: code)) { result in
                switch result {
                case .success(let response):
                    let data = response.data
                    let decoder = JSONDecoder()
                    
                    do {
                        let token = try decoder.decode(Token.self, from: data)
                        self.accessToken = token.access_token
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}


