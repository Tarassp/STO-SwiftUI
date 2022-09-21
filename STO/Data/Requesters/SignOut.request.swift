//
//  SignOut.request.swift
//  STO
//
//  Created by Taras Spasibov on 16.06.2022.
//

import Foundation

enum SignOutRequest: Request {
    typealias Output = Void
    
    case signOut
    
    var path: String { "/api/sign-out" }
    
    var httpMethod: HTTPMethod { .get }
    
    var addAuthorizationToken: Bool { true }
    
    func decode(_ data: Data) throws -> Void {
        
    }
    
}
