//
//  AuthRepository.swift
//  Domain
//
//  Created by 신동규 on 5/18/24.
//

import Foundation
import Combine

public protocol AuthRepository {
    var accessToken: AnyPublisher<String?, Never> { get }
    
    func requestCode()
    func requestAccessToken(code: String) async throws
}
