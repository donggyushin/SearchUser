//
//  LogoutUsecase.swift
//  Domain
//
//  Created by 신동규 on 5/18/24.
//

import Foundation

public final class LogoutUsecase {
    private let authRepository: AuthRepository
    
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    public func implement() {
        authRepository.logout()
    }
}
