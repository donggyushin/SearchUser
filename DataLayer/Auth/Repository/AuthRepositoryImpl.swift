//
//  AuthRepositoryImpl.swift
//  DataLayer
//
//  Created by 신동규 on 5/17/24.
//

import UIKit
import Moya
import Domain
import Combine

// https://hilily.tistory.com/38
public final class AuthRepositoryImpl: AuthRepository {
    public static let shared = AuthRepositoryImpl()
    
    public var accessToken: AnyPublisher<String?, Never> { $_accessToken.eraseToAnyPublisher() }
    @Published var _accessToken: String? = TokenKeychainManager().get()
    
    private init() { }
    
    public func logout() {
        _accessToken = nil
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
                        self._accessToken = token.access_token
                        TokenKeychainManager().post(token: token.access_token)
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
