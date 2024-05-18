//
//  UserRepositoryImpl.swift
//  DataLayer
//
//  Created by 신동규 on 5/18/24.
//

import Foundation
import Domain
import Moya

public final class UserRepositoryImpl: UserRepository {
    public static let shared = UserRepositoryImpl()
    
    private init() { }
    
    public func get(query: String, page: Int, perPage: Int) async throws -> ([Domain.User], totalCount: Int) {
        return try await withCheckedThrowingContinuation { continuation in
            let provider = MoyaProvider<GithubAPI>()
            provider.request(.users(query: query, page: page, perPage: perPage)) { result in
                switch result {
                case .success(let response):
                    let data = response.data
                    let decoder = JSONDecoder()
                    
                    do {
                        let userResponse = try decoder.decode(SearchUserResponse.self, from: data)
                        continuation.resume(returning: (userResponse.items.map({ $0.domain }), userResponse.totalCount))
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
