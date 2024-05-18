//
//  AuthRepositoryImpl.swift
//  MockData
//
//  Created by 신동규 on 5/18/24.
//

import Foundation
import Domain
import Combine

public final class AuthRepositoryImpl: AuthRepository {
    public var accessToken: AnyPublisher<String?, Never> { $_accessToken.eraseToAnyPublisher() }
    @Published var _accessToken: String? = nil
    
    public init() { }
    
    public func requestCode() { }
    
    public func requestAccessToken(code: String) async throws { }
}
