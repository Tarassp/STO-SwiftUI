//
//  DefaultUser.repository.swift
//  STO
//
//  Created by Taras Spasibov on 02.06.2022.
//

import Combine
import Foundation
import os

final class DefaultUserSessionRepository {
    private let storage: UserSessionKeychainStorage
    private let signInRepository: SignInRepository
    private let authorizedUserRepository: AuthorizedUserRepository

    // MARK: - Methods
    init(signInRepository: SignInRepository = DefaultSignInRepository(), authorizedUserRepository: AuthorizedUserRepository = DefaultAuthorizedUserRepository(), keychainStorage storage: UserSessionKeychainStorage = DefaultUserSessionKeychainStorage()) {
        self.signInRepository = signInRepository
        self.authorizedUserRepository = authorizedUserRepository
        self.storage = storage
    }

    deinit {
        print("\(type(of: self)): \(#function)")
    }
}

extension DefaultUserSessionRepository: UserSessionRepository {
    
    func signIn(email: String, password: String) -> AnyPublisher<UserSession, ErrorMessage> {
        signInRepository
            .signIn(email: email, password: password)
            .map { [unowned self] userToken in
                self.authorizedUserRepository
                    .execute(token: userToken)
                    .map { profile in
                        UserSession(profile: profile, remoteSession: userToken)
                    }
            }
            .switchToLatest()
            .map(storage.save(userSession:))
            .switchToLatest()
            .eraseToAnyPublisher()
    }
    
    func readUserSession() -> AnyPublisher<UserSession?, ErrorMessage> {
        storage.getUserSession()
    }
    
    func deleteUserSession() -> AnyPublisher<Void, ErrorMessage> {
        storage.deleteUserSession()
    }
}
