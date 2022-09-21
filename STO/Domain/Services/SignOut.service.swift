//
//  SignOut.service.swift
//  STO
//
//  Created by Taras Spasibov on 24.06.2022.
//

import Foundation
import Combine

protocol SignOutService {
    var outputs: AnyPublisher<Void, Never> { get }
    var error: AnyPublisher<ErrorMessage, Never> { get }
    var isRunning: AnyPublisher<Bool, Never> { get }
    func execute()
}


final class DefaultSignOutService: SignOutService {
    static var numberOfObject = 0
    private let trigger = PassthroughSubject<Void, Never>()
    
    let outputs: AnyPublisher<Void, Never>
    let error: AnyPublisher<ErrorMessage, Never>
    let isRunning: AnyPublisher<Bool, Never>
    
    init(signOutRepository: SignOutRepository = DefaultSignOutRepository()) {
        DefaultSignOutService.numberOfObject += 1
        let isRunningSubject = PassthroughSubject<Bool, Never>()
        let errorSubject = PassthroughSubject<ErrorMessage, Never>()
        isRunning = isRunningSubject.eraseToAnyPublisher()
        error = errorSubject.eraseToAnyPublisher()
        
        outputs = trigger
            .map {
                signOutRepository
                    .signOut()
                    .progress(isExecuting: isRunningSubject)
                    .catch { error -> Empty<Void, Never> in
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
        DefaultSignOutService.numberOfObject -= 1
        print("\(type(of: self)): \(#function) Left: \(DefaultSignOutService.numberOfObject)")
    }
}
