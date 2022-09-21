//
//  RefreshToken.request.swift
//  STO
//
//  Created by Taras Spasibov on 16.06.2022.
//

import Foundation
enum RefreshTokenRequest: Request {
    typealias Output = UserTokenDto
    
    case configure(token: String)
    
    var path: String { "/api/refresh" }
    
    var httpMethod: HTTPMethod { .get }
    
    var addAuthorizationToken: Bool { false }
    
    var headers: [String : String]? {
        if case .configure(let token) = self {
            return ["Authorization": "Bearer \(token)"]
        }
        return nil
    }
}
