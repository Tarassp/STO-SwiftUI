//
//  UserSessionKeychain.storage.swift
//  STO
//
//  Created by Taras Spasibov on 10.06.2022.
//

import Foundation
import Combine

protocol UserSessionKeychainStorage {
    func save(userToken: UserToken) -> AnyPublisher<UserSession, ErrorMessage>
    func save(userSession: UserSession) -> AnyPublisher<UserSession, ErrorMessage>
    func getUserSession() -> AnyPublisher<UserSession?, ErrorMessage>
    func getUserToken() -> AnyPublisher<UserToken?, ErrorMessage>
    func deleteUserSession() -> AnyPublisher<Void, ErrorMessage>
}

final class DefaultUserSessionKeychainStorage: UserSessionKeychainStorage {
    
    private let keychainStorage: KeychainStorage
    
    init(keychainStorage: KeychainStorage = DefaultKeychainStorage.shared) {
        self.keychainStorage = keychainStorage
    }
    
    func save(userSession: UserSession) -> AnyPublisher<UserSession, ErrorMessage> {
        keychainStorage
            .set(userSession, forKey: .userSession)
            .mapError(transformError(_:))
            .eraseToAnyPublisher()
    }
    
    func save(userToken: UserToken) -> AnyPublisher<UserSession, ErrorMessage> {
        keychainStorage
            .value(forKey: .userSession)
            .tryMap { (userSession: UserSession?) in
                guard let session = userSession else { throw StorageError.invalidSaveUserToken }
                return UserSession(profile: session.profile, remoteSession: userToken)
            }
            .flatMap { userSession in
                self.keychainStorage
                    .set(userSession, forKey: .userSession)
            }
            .mapError(transformError(_:))
            .eraseToAnyPublisher()
    }
    
    func getUserSession() -> AnyPublisher<UserSession?, ErrorMessage> {
        keychainStorage
            .value(forKey: .userSession)
            .mapError(transformError(_:))
            .eraseToAnyPublisher()
    }
    
    func getUserToken() -> AnyPublisher<UserToken?, ErrorMessage> {
        getUserSession()
            .map(\.?.remoteSession)
            .eraseToAnyPublisher()
    }
    
    func deleteUserSession() -> AnyPublisher<Void, ErrorMessage> {
        keychainStorage
            .removeObject(forKey: .userSession)
            .mapError(transformError(_:))
            .eraseToAnyPublisher()
    }
    
    private func transformError(_ error: Error) -> ErrorMessage {
        let errorMessage: ErrorMessage
        switch error {
        case let keychainError as KeychainError:
            errorMessage = ErrorMessage(title: "Keychain Error", message: keychainError.message)
        case let storageError as StorageError:
            errorMessage = ErrorMessage(title: "Storage Error", message: storageError.message)
        default:
            errorMessage = ErrorMessage(title: "Keychain Error", message: error.localizedDescription)
        }
        return errorMessage
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
}


extension DefaultUserSessionKeychainStorage {
    enum StorageError: LocalizedError {
        case invalidSaveUserToken
        
        public var message: String {
            switch self {
            case .invalidSaveUserToken:
                return "Can't save User Token because UserSession is missing"
            }
        }
    }
}
