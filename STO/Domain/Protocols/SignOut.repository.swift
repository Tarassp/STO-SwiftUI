//
//  SignOut.repository.swift
//  STO
//
//  Created by Taras Spasibov on 24.06.2022.
//

import Foundation
import Combine

protocol SignOutRepository {
    func signOut() -> AnyPublisher<Void, ErrorMessage>
}
