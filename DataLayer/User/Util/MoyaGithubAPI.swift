//
//  Moya.swift
//  Data
//
//  Created by 신동규 on 5/17/24.
//

import Alamofire
import Moya

/// https://www.kodeco.com/5121-moya-tutorial-for-ios-getting-started

enum GithubAPI {
    case users(query: String, page: Int)
}

extension GithubAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .users: return "/search/users"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .users: return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .users(let query, let page):
            return .requestParameters(
                parameters: [
                    "q": query,
                    "page": page
                ],
                encoding: URLEncoding.queryString
            )
        }
    }
    
    var headers: [String : String]? {
        [
            "Content-Type": "application/json",
            "Accept": "application/vnd.github+json",
            "Authorization": "Bearer \(AuthRepositoryImpl.shared._accessToken ?? "")"
        ]
    }
}
