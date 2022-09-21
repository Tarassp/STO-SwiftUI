//
//  UserSessionRepository.swift
//  STO
//
//  Created by Taras Spasibov on 02.06.2022.
//

import Combine

protocol UserSessionRepository {
    func signIn(email: String, password: String) -> AnyPublisher<UserSession, ErrorMessage>
    func readUserSession() -> AnyPublisher<UserSession?, ErrorMessage>
}
