//
//  MoyaGithub.swift
//  Data
//
//  Created by 신동규 on 5/17/24.
//

import Alamofire
import Moya

enum Github {
    static private let clientID = "Ov23ctO8MVeCSW1Otcnb"
    static private let clientSecret = "2ec66762a464132716564e0ec931f277eb5f8742"
    
    case token(code: String)
}

extension Github: TargetType {
    var baseURL: URL {
        URL(string: "https://github.com")!
    }
    
    var path: String {
        switch self {
        case .token: return "/login/oauth/access_token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .token: return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .token(let code):
            
            struct Body: Encodable {
                let client_id: String
                let client_secret: String
                let code: String
            }
            
            let body = Body(client_id: Self.clientID,
                            client_secret: Self.clientSecret,
                            code: code)
            
            return .requestJSONEncodable(body)
        }
    }
    
    var headers: [String : String]? {
        ["Accept": "application/json"]
    }
    
    
}
