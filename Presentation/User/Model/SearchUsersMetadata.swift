//
//  SearchUsersMetadata.swift
//  Presentation
//
//  Created by 신동규 on 5/18/24.
//

import Foundation

struct SearchUsersMetadata {
    let query: String
    var page: Int
    var canGetMoreUsers: Bool
    
    init(query: String) {
        self.query = query
        page = 1
        canGetMoreUsers = false
    }
}
