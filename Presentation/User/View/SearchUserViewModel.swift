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
    @Published private(set) var showEmptyUserListView: Bool = false
    @Published private var metadata: SearchUsersMetadata = .init(query: "")
    
    private let searchUserUsecase: SearchUserUsecase
    
    init(userRepository: UserRepository) {
        searchUserUsecase = .init(userRepository: userRepository)
    }
    
    private var searchTask: Task<(), Error>? = nil
    func search() {
        guard searchTask == nil else { return }
        searchTask = Task {
            do {
                errorMessage = nil
                loading = true
                metadata = .init(query: query)
                let (users, totalCount) = try await searchUserUsecase.implement(query: query, page: metadata.page)
                self.users = users.map({ .init(domain: $0) })
                self.showEmptyUserListView = users.isEmpty
                metadata.page += 1
                metadata.canGetMoreUsers = self.users.count < totalCount
            } catch {
                errorMessage = error.localizedDescription
            }
            loading = false
            searchTask = nil
        }
    }
    
    private var loadMoreUsersTask: Task<(), Error>? = nil
    func loadMoreUsers() {
        guard loadMoreUsersTask == nil else { return }
        guard metadata.canGetMoreUsers == true else { return }
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
            loadMoreUsersTask = nil
            loading = false
        }
    }
}
