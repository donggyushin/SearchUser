//
//  User.swift
//  Domain
//
//  Created by 신동규 on 5/18/24.
//

import Foundation

public struct User {
    public let id: String
    public let login: String
    public let avatarUrl: String?
    public let url: String
    
    public init(id: String, login: String, avatarUrl: String?, url: String) {
        self.id = id
        self.login = login
        self.avatarUrl = avatarUrl
        self.url = url
    }
}
