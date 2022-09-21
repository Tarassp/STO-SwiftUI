//
//  DefaultSignOut.repository.swift
//  STO
//
//  Created by Taras Spasibov on 24.06.2022.
//

import Foundation
import Combine

final class DefaultSignOutRepository: SignOutRepository {
    private let networkManager: NetworkManagerProtocol
    private let storage: UserSessionKeychainStorage
    
    // MARK: - Methods
    init(networkManager: NetworkManagerProtocol = RequestManager(), userSessionStorage storage: UserSessionKeychainStorage = DefaultUserSessionKeychainStorage()) {
        self.networkManager = networkManager
        self.storage = storage
    }
    
    func signOut() -> AnyPublisher<Void, ErrorMessage> {
        networkManager
            .execute(SignOutRequest.signOut)
            .flatMap { [weak self] in
                self?.storage.deleteUserSession() ?? Empty<Void, ErrorMessage>().eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
}
