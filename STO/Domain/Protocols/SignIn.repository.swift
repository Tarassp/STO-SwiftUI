//
//  SignIn.repository.swift
//  STO
//
//  Created by Taras Spasibov on 09.06.2022.
//

import Foundation
import Combine

protocol SignInRepository {
    func signIn(email: String, password: String) -> AnyPublisher<UserToken, ErrorMessage>
}
