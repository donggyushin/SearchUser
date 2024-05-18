//
//  SearchUserViewModel.swift
//  Presentation
//
//  Created by 신동규 on 5/18/24.
//

import Foundation
import Combine
import Domain

final class SearchUserViewModel {
    @Published var query: String = ""
    @Published private(set) var users: [User] = []
    @Published private(set) var loading: Bool = false
    @Published private(set) var errorMessage: String? = nil
    @Published private var metadata: SearchUsersMetadata = .init(query: "", page: 0, canGetMoreUsers: true)
    
    private let searchUserUsecase: SearchUserUsecase
    
    init(userRepository: UserRepository) {
        searchUserUsecase = .init(userRepository: userRepository)
    }
    
    private var searchTask: Task<(), Error>? = nil
    func search() {
        reinitialize()
        guard metadata.canGetMoreUsers == true else { return }
        guard searchTask == nil else { return }
        searchTask = Task {
            do {
                errorMessage = nil
                loading = true
                let (users, totalCount) = try await searchUserUsecase.implement(query: query, page: metadata.page)
                self.users.append(contentsOf: users.map({ .init(domain: $0) }))
                
                metadata.page += 1
                metadata.canGetMoreUsers = self.users.count < totalCount
            } catch {
                errorMessage = error.localizedDescription
            }
            loading = false
        }
    }
    
    private var loadMoreUsersTask: Task<(), Error>? = nil
    func loadMoreUsers() {
        guard metadata.canGetMoreUsers == true else { return }
        guard loadMoreUsersTask == nil else { return }
        loadMoreUsersTask = Task {
            do {
                errorMessage = nil
                loading = true
                let (users, totalCount) = try await searchUserUsecase.implement(query: metadata.query, page: metadata.page)
                self.users.append(contentsOf: users.map({ .init(domain: $0) }))
                
                metadata.page += 1
                metadata.canGetMoreUsers = self.users.count < totalCount
            } catch {
                errorMessage = error.localizedDescription
            }
            loading = false
        }
    }
    
    private func reinitialize() {
        if query != metadata.query {
            metadata = .init(query: query, page: 1, canGetMoreUsers: true)
            self.users = []
        }
    }
}
