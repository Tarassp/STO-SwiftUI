//
//  DefaultAuthorizedUser.repository.swift
//  STO
//
//  Created by Taras Spasibov on 09.06.2022.
//

import Foundation
import Combine


final class DefaultAuthorizedUserRepository {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = RequestManager()) {
        self.networkManager = networkManager
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
}

extension DefaultAuthorizedUserRepository: AuthorizedUserRepository {
    func execute(token: UserToken?) -> AnyPublisher<UserProfile, ErrorMessage> {
        networkManager
            .execute(AuthorizedUserRequest.me(token: token))
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
}
