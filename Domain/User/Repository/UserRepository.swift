//
//  UserRepository.swift
//  Domain
//
//  Created by 신동규 on 5/18/24.
//

import Foundation

public protocol UserRepository {
    func get(query: String, page: Int) async throws -> ([User], totalCount: Int)
}
