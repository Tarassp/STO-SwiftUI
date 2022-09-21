//
//  SignInRequest.request.swift
//  STO
//
//  Created by Taras Spasibov on 01.06.2022.
//

import Foundation

enum SignInRequest: Request {
    typealias Output = UserTokenDto
    
    case configure(email: String, password: String)
    
    var path: String { "/api/sign-in" }
    
    var httpMethod: HTTPMethod { .post }
    
    var addAuthorizationToken: Bool { false }
    
    var params: [String : Any]? {
        switch self {
        case .configure(let email, let password):
            return [
                "email": email,
                "password": password
            ]
        }
    }
}
