//
//  SignIn.service.swift
//  STO
//
//  Created by Taras Spasibov on 08.06.2022.
//

import Foundation
import Combine

protocol SignInService {
    var outputs: AnyPublisher<UserToken, Never> { get }
    var error: AnyPublisher<ErrorMessage, Never> { get }
    var isRunning: AnyPublisher<Bool, Never> { get }
    func execute(email: String, password: String)
}

final class DefaultSignInService: SignInService {
    private let trigger = PassthroughSubject<(String, String), Never>()
    
    let outputs: AnyPublisher<UserToken, Never>
    let error: AnyPublisher<ErrorMessage, Never>
    let isRunning: AnyPublisher<Bool, Never>
    
    init(signInRepository: SignInRepository = DefaultSignInRepository()) {
        let isRunningSubject = PassthroughSubject<Bool, Never>()
        let errorSubject = PassthroughSubject<ErrorMessage, Never>()
        isRunning = isRunningSubject.eraseToAnyPublisher()
        error = errorSubject.eraseToAnyPublisher()
        
        outputs = trigger
            .map { email, password in
                signInRepository
                    .signIn(email: email, password: password)
                    .progress(isExecuting: isRunningSubject)
                    .catch { error -> Empty<UserToken, Never> in
                        errorSubject.send(error)
                        return Empty()
                    }
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
    
    func execute(email: String, password: String) {
        trigger.send((email, password))
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
}
