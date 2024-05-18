//
//  UserRepositoryImpl.swift
//  Presentation
//
//  Created by 신동규 on 5/18/24.
//

import Foundation
import Domain

final class UserRepositoryImpl: UserRepository {
    func get(query: String, page: Int, perPage: Int) async throws -> ([Domain.User], totalCount: Int) {
        let users: [Domain.User] = [
            USER_1,
            USER_2,
            USER_3,
            USER_4
        ]
        
        let totalCount = 12
        
        return (users, totalCount)
    }
}