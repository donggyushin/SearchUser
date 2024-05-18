//
//  User.swift
//  DataLayer
//
//  Created by 신동규 on 5/18/24.
//

import Foundation
import Domain

struct User: Codable {
    let id: Int
    let login: String
    let avatarUrl: String
    let url: String
    
    init(domain: Domain.User) {
        id = domain.id
        login = domain.login
        avatarUrl = domain.avatarUrl
        url = domain.url
    }
    
    var domain: Domain.User {
        .init(id: id,
              login: login,
              avatarUrl: avatarUrl,
              url: url)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
        case url = "html_url"
    }
}
