//
//  SearchUserResponse.swift
//  DataLayer
//
//  Created by 신동규 on 5/18/24.
//

import Foundation

struct SearchUserResponse: Codable {
    let totalCount: Int
    let items: [User]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}
