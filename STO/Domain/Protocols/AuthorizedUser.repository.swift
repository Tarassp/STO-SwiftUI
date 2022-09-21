//
//  AuthorizedUser.repository.swift
//  STO
//
//  Created by Taras Spasibov on 09.06.2022.
//

import Foundation
import Combine

protocol AuthorizedUserRepository {
    func execute(token: UserToken?) -> AnyPublisher<UserProfile, ErrorMessage>
}
