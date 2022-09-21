//
//  DefaultSignIn.repository.swift
//  STO
//
//  Created by Taras Spasibov on 09.06.2022.
//
import Combine

final class DefaultSignInRepository {
    private let networkManager: NetworkManagerProtocol
    private let storage: UserSessionKeychainStorage
    
    // MARK: - Methods
    init(networkManager: NetworkManagerProtocol = RequestManager(), userSessionStorage storage: UserSessionKeychainStorage = DefaultUserSessionKeychainStorage()) {
        self.networkManager = networkManager
        self.storage = storage
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
}

extension DefaultSignInRepository: SignInRepository {
    func signIn(email: String, password: String) -> AnyPublisher<UserToken, ErrorMessage> {
        networkManager
            .execute(SignInRequest.configure(email: email, password: password))
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
}
