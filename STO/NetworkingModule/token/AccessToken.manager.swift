//
//  AccessToken.manager.swift
//  STO
//
//  Created by Taras Spasibov on 07.06.2022.
//

import Foundation
import Combine
import JWTDecode

enum AccessTokenManagerError: LocalizedError {
    case userTokenIsMissing
    case accessTokenIsMissing
    case refreshTokenIsMissing
    case invalidDecodeAccessToken(String)
    case expired
    
    var message: String {
        switch self {
        case .userTokenIsMissing:
            return "User Token Is Missing"
        case .accessTokenIsMissing:
            return "Access Token Is Missing"
        case .refreshTokenIsMissing:
            return "Refresh Token Is Missing"
        case .invalidDecodeAccessToken(let message):
            return "Invalid decode Access Token: \(message)"
        case .expired:
            return "Token is expired!"
        }
    }
}

protocol AccessTokenManager {
    func getAccessToken() -> AnyPublisher<AuthToken, Error>
    func getRefreshToken() -> AnyPublisher<AuthToken, Error>
    func saveUserToken(_ userToken: UserToken) -> AnyPublisher<UserToken, ErrorMessage>
}

final class DefaultAccessTokenManager: AccessTokenManager {
    
    private let sessionKeychainStorage: UserSessionKeychainStorage
    private var accessToken: AuthToken?
    
    init(sessionKeychainStorage: UserSessionKeychainStorage = DefaultUserSessionKeychainStorage()) {
        self.sessionKeychainStorage = sessionKeychainStorage
    }
    
    
    private func getAccessToken(userToken: UserToken?) throws -> AuthToken {
        guard let userToken = userToken else {
            throw AccessTokenManagerError.userTokenIsMissing
        }
        guard userToken.accessToken.isNotEmptyOrWhitespace else {
            throw AccessTokenManagerError.accessTokenIsMissing
        }
        do {
            let jwt = try decode(jwt: userToken.accessToken)
            if jwt.expired {
                throw AccessTokenManagerError.expired
            } else {
                return userToken.accessToken
            }
        }
//        catch let error as NSError {
//            throw AccessTokenManagerError.invalidDecodeAccessToken(error.localizedDescription)
//        }
    }
    
    private func getRefreshToken(userToken: UserToken?) throws -> AuthToken {
        guard let userToken = userToken else {
            throw AccessTokenManagerError.userTokenIsMissing
        }
        guard userToken.refreshToken.isNotEmptyOrWhitespace else {
            throw AccessTokenManagerError.refreshTokenIsMissing
        }
        return userToken.refreshToken
    }
    
    func getAccessToken() -> AnyPublisher<AuthToken, Error> {
        sessionKeychainStorage
            .getUserToken()
            .tryMap { [unowned self] userToken in
                try self.getAccessToken(userToken: userToken)
            }
            .eraseToAnyPublisher()
    }
    
    func saveUserToken(_ userToken: UserToken) -> AnyPublisher<UserToken, ErrorMessage> {
        sessionKeychainStorage
            .save(userToken: userToken)
            .map(\.remoteSession)
            .eraseToAnyPublisher()
    }
    
    func getRefreshToken() -> AnyPublisher<AuthToken, Error> {
        sessionKeychainStorage
            .getUserToken()
            .tryMap { [unowned self] userToken in
                try self.getRefreshToken(userToken: userToken)
            }
            .eraseToAnyPublisher()
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
}
