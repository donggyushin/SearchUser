//
//  UserRepositoryImpl.swift
//  Presentation
//
//  Created by 신동규 on 5/18/24.
//

import Foundation
import Domain

public final class UserRepositoryImpl: UserRepository {
    public init() { }
    
    public func get(query: String, page: Int, perPage: Int) async throws -> ([Domain.User], totalCount: Int) {
        let users: [Domain.User] = [
            USER_1,
            USER_2,
            USER_3,
            USER_4
        ]
        
        let totalCount = users.count
        
        return (users, totalCount)
    }
}
