//
//  TokenKeychainManager.swift
//  DataLayer
//
//  Created by 신동규 on 5/18/24.
//

import Foundation
import Security

final class TokenKeychainManager {
    
    let service = "com.donggyu.searchapp"
    let identifier = "com.donggyu.searchapp.accesstoken"
    
    func post(token: String) {
        
        guard let data = token.data(using: .utf8) else { return }
        
        
        let query: CFDictionary = [
            // 암호화 불필요
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: identifier,
            kSecValueData: data
        ] as CFDictionary
        
        SecItemAdd(query, nil)
    }
    
    func get() -> String? {
        let query: CFDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: identifier,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        guard let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
