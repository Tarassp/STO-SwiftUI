//
//  UserToken.dto.swift
//  STO
//
//  Created by Taras Spasibov on 06.06.2022.
//

import Foundation

struct UserTokenDto: Codable {
    let accessToken: String
    let refreshToken: String
}

extension UserTokenDto {
    func toDomain() -> UserToken {
        .init(accessToken: accessToken, refreshToken: refreshToken)
    }
}
