//
//  AuthorizedUser.request.swift
//  STO
//
//  Created by Taras Spasibov on 09.06.2022.
//

import Foundation

enum AuthorizedUserRequest: Request {
    typealias Output = UserProfileDto
    
    case me(token: UserToken?)
    
    var path: String { "/api/me" }
    
    var headers: [String : String]? {
        if case .me(let token) = self, let token = token {
            return ["Authorization": token.bearerAccessToken]
        }
        return nil
    }
    
    var addAuthorizationToken: Bool {
        if case .me(let token) = self, token.isNotNil {
            return false
        }
        return true
    }
    
    var httpMethod: HTTPMethod { .get }
}
