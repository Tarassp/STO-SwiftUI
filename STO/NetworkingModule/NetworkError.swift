//
//  NetworkError.swift
//  STO
//
//  Created by Taras Spasibov on 01.06.2022.
//

import Foundation

public enum NetworkError: LocalizedError {
    case invalidServerResponse
    case invalidURL
    case invalidParseResponse(String)
    case missingToken
    case unauthorized
    case resposeError(ErrorResponseDto)
    
    public var message: String {
        switch self {
        case .invalidServerResponse:
            return "The server returned an invalid response."
        case .invalidURL:
            return "URL string is malformed."
        case .invalidParseResponse(let error):
            return "PARSE ERROR: \(error)"
        case .missingToken:
            return "Token is missing"
        case .unauthorized:
            return "Unauthorized. Please re-Sign In"
        case .resposeError(let error):
            return "Server Response Error: \(error.message)"
        }
    }
}

extension NetworkError {
    var isUnauthorized: Bool {
        if case .unauthorized = self {
            return true
        }
        return false
        
    }
}

extension Error {
    public var asNetworkError: NetworkError? {
        (self as? NetworkError)
    }
}
