//
//  UserToken.entity.swift
//  STO
//
//  Created by Taras Spasibov on 02.06.2022.
//

import Foundation
public typealias AuthToken = String

public struct UserToken: Codable {
    let accessToken: AuthToken
    let refreshToken: AuthToken
    
    // MARK: - Methods
    public init(accessToken: AuthToken, refreshToken: AuthToken) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    var bearerAccessToken: String {
      "Bearer \(accessToken)"
    }
}

extension UserToken: Equatable {
    public static func ==(lhs: UserToken, rhs: UserToken) -> Bool {
        lhs.accessToken == rhs.accessToken && lhs.refreshToken == rhs.refreshToken
    }
}

extension UserToken {
    static let empty = UserToken(accessToken: "", refreshToken: "")
}
