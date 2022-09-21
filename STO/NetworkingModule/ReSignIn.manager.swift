//
//  ReSignIn.manager.swift
//  STO
//
//  Created by Taras Spasibov on 16.06.2022.
//

import Combine

protocol ReSignInManager {
    func reSignIn()
    func signedIn(to userSession: UserSession)
    var reSignInIsNeeded: AnyPublisher<Bool, Never> { get }
}

final class DefaultReSignInManager: ReSignInManager {
    
    static let shared = DefaultReSignInManager()
    private init() {}
    
    
    private let reSignInIsNeededPublisher = PassthroughSubject<Bool, Never>()
    
    var reSignInIsNeeded: AnyPublisher<Bool, Never> {
        reSignInIsNeededPublisher.eraseToAnyPublisher()
    }
    
    
    func reSignIn() {
        reSignInIsNeededPublisher.send(true)
    }
    
    func signedIn(to userSession: UserSession) {
        reSignInIsNeededPublisher.send(false)
    }
}
