//
//  SearchUserUsecase.swift
//  Domain
//
//  Created by 신동규 on 5/18/24.
//

import Foundation

public final class SearchUserUsecase {
    private let userRepository: UserRepository
    
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func implement(query: String, page: Int, perPage: Int = 30) async throws -> ([User], totalCount: Int) {
        try await userRepository.get(query: query, page: page)
    }
}
