//
//  UserSession.dto.swift
//  STO
//
//  Created by Taras Spasibov on 02.06.2022.
//

import Foundation

struct UserProfileDto: Codable {
    let firstName: String
    let lastName: String
    let email: String
//    let mobileNumber: String?
//    let avatarUrl: String?
}

extension UserProfileDto {
    func toDomain() -> UserProfile {
        .init(firstName: firstName, lastName: lastName, email: email)
    }
}
