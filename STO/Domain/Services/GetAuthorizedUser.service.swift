//
//  GetAuthorizedUser.service.swift
//  STO
//
//  Created by Taras Spasibov on 09.06.2022.
//

import Foundation
import Combine

protocol GetAuthorizedUserService {
    var outputs: AnyPublisher<UserProfile, Never> { get }
    var error: AnyPublisher<ErrorMessage, Never> { get }
    var isRunning: AnyPublisher<Bool, Never> { get }
    func execute()
}

final class DefaultGetAuthorizedUserService: GetAuthorizedUserService {
    private let trigger = PassthroughSubject<Void, Never>()
    
    let outputs: AnyPublisher<UserProfile, Never>
    let error: AnyPublisher<ErrorMessage, Never>
    let isRunning: AnyPublisher<Bool, Never>
    
    init(authorizedUserRepository: AuthorizedUserRepository = DefaultAuthorizedUserRepository()) {
        let isRunningSubject = PassthroughSubject<Bool, Never>()
        let errorSubject = PassthroughSubject<ErrorMessage, Never>()
        isRunning = isRunningSubject.eraseToAnyPublisher()
        error = errorSubject.eraseToAnyPublisher()
        
        outputs = trigger
            .map {
                authorizedUserRepository
                    .execute(token: nil)
                    .progress(isExecuting: isRunningSubject)
                    .catch { error -> Empty<UserProfile, Never> in
                        errorSubject.send(error)
                        return Empty()
                    }
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
    
    func execute() {
        trigger.send()
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
}
