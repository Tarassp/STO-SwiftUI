//
//  Test.request.swift
//  STO
//
//  Created by Taras Spasibov on 16.06.2022.
//

import Foundation

enum TestRequest: Request {
    typealias Output = Void
    
    case test
    var path: String { "/api/test" }
    
    var httpMethod: HTTPMethod { .get }
    
    var addAuthorizationToken: Bool { true }
    
    func decode(_ data: Data) throws -> Void {
        
    }
}
