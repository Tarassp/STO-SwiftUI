//
//  GetUserSession.service.swift
//  STO
//
//  Created by Taras Spasibov on 03.06.2022.
//

import Foundation
import Combine

protocol GetUserSessionService {
    var outputs: AnyPublisher<UserSession?, Never> { get }
    var error: AnyPublisher<ErrorMessage, Never> { get }
    var isRunning: AnyPublisher<Bool, Never> { get }
    func fetch(email: String, password: String)
    func read()
}


final class DefaultGetUserSessionService: GetUserSessionService {
    private let trigger = PassthroughSubject<Storage, Never>()
    
    let outputs: AnyPublisher<UserSession?, Never>
    let error: AnyPublisher<ErrorMessage, Never>
    let isRunning: AnyPublisher<Bool, Never>
    
    init(userSessionRepository: UserSessionRepository = DefaultUserSessionRepository()) {
        let isRunningSubject = PassthroughSubject<Bool, Never>()
        let errorSubject = PassthroughSubject<ErrorMessage, Never>()
        isRunning = isRunningSubject.eraseToAnyPublisher()
        error = errorSubject.eraseToAnyPublisher()
        
        outputs = trigger
            .map { storage -> AnyPublisher<UserSession?, Never> in
                let publisher: AnyPublisher<UserSession?, ErrorMessage>
                if case .remote(let email, let password) = storage {
                    publisher = userSessionRepository
                        .signIn(email: email, password: password)
                        .map { Optional($0) }
                        .eraseToAnyPublisher()
                        
                } else {
                    publisher = userSessionRepository
                        .readUserSession()
                }
                
                return publisher
                    .catch { error -> Just<UserSession?> in
                        errorSubject.send(error)
                        return Just(nil)
                    }
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
    
    func fetch(email: String, password: String) {
        trigger.send(.remote(email, password))
    }
    
    func read() {
        trigger.send(.local)
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
}

private extension DefaultGetUserSessionService {
    enum Storage {
        case local
        case remote(String, String)
    }
}
