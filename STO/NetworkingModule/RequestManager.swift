//
//  NetworkManager.swift
//  STO
//
//  Created by Taras Spasibov on 01.06.2022.
//

import Foundation
import Combine
import os

public protocol NetworkMangerDelegate {
    
}

public protocol NetworkManagerProtocol {
    var networker: Networking { get }
    var parser: DataParserProtocol { get }
    func execute<R: Request>(_ request: R) -> AnyPublisher<R.Output, ErrorMessage>
}


public class RequestManager: NetworkManagerProtocol {
    public let networker: Networking
    private let accessTokenManager: AccessTokenManager
    private let reSignInManager: ReSignInManager
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
            category: String(describing: RequestManager.self))
    
    init(networker: Networking = Networker(),
         accessToken: AccessTokenManager = DefaultAccessTokenManager(),
         reSignInManager: ReSignInManager = DefaultReSignInManager.shared) {
        self.networker = networker
        self.accessTokenManager = accessToken
        self.reSignInManager = reSignInManager
    }
    
    public func execute<R: Request>(_ request: R) -> AnyPublisher<R.Output, ErrorMessage> {
        let dataTask: AnyPublisher<R.Output, Error>

        if request.addAuthorizationToken {
            dataTask = requestAccessToken()
                .tryMap { [weak self] token in
                    self!.networker.perform(request, authToken: token)
                }
                .switchToLatest()
                .eraseToAnyPublisher()
        } else {
            dataTask = networker.perform(request, authToken: nil)
        }
        
        return dataTask
            .tryCatch { [weak self] error -> AnyPublisher<R.Output, Error> in
                if let error = error.asNetworkError, error.isUnauthorized {
                    self?.reSignInManager.reSignIn()
                }
                throw error
            }
            .mapError(transformError(_:))
            .eraseToAnyPublisher()
    }
    
    private func requestAccessToken() -> AnyPublisher<AuthToken, Error> {
        accessTokenManager
            .getAccessToken()
            .tryCatch { [unowned self] error -> AnyPublisher<AuthToken, Error> in
                guard let error = error as? AccessTokenManagerError, case .expired = error else {
                    throw error
                }
                return self.refreshAccessToken()
            }
            .eraseToAnyPublisher()
    }
    
    private func refreshAccessToken() -> AnyPublisher<AuthToken, Error> {
        accessTokenManager
            .getRefreshToken()
            .map { [unowned self] token in
                self.networker
                    .perform(RefreshTokenRequest.configure(token: token), authToken: nil)
            }
            .switchToLatest()
            .map { dto in
                _ = self.accessTokenManager.saveUserToken(dto.toDomain())
                return dto.refreshToken
            }
            .eraseToAnyPublisher()
    }
    
    private func transformError(_ error: Error) -> ErrorMessage {
        let errorMessage: ErrorMessage
        switch error {
        case let networkError as NetworkError:
            if case .resposeError(let error) = networkError {
                errorMessage = ErrorMessage(title: "Server Response Error", message: error.message, code: error.code)
            } else {
                errorMessage = ErrorMessage(title: "NetworkError", message: networkError.message)
            }
        case let tokenManagerError as AccessTokenManagerError:
            errorMessage = ErrorMessage(title: "AccessTokenManagerError", message: tokenManagerError.message)
        case URLError.notConnectedToInternet:
            errorMessage = ErrorMessage(title: "No Internet Connection", message: "Please check your internet connection")
        case URLError.dataNotAllowed:
            errorMessage = ErrorMessage(title: "No Internet Connection", message: "The cellular network disallowed a connection.", code: -1020)
        default:
            errorMessage = ErrorMessage(title: "Default Error", message: (error as NSError).debugDescription)
        }
        logger.error("\(ErrorMessageGenerator.generate(errorMessage))")
        return errorMessage
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
}

// MARK: - Returns Data Parser
extension NetworkManagerProtocol {
    public var parser: DataParserProtocol {
        return DataParser()
    }
}
