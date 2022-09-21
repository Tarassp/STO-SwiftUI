//
//  Request.swift
//  STO
//
//  Created by Taras Spasibov on 01.06.2022.
//

import Foundation

public protocol Request {
    associatedtype Output
    var path: String { get }
    var headers: [String: String]? { get }
    var params: [String: Any]? { get }
    var urlParams: [String: String?]? { get }
    var httpMethod: HTTPMethod { get }
    var addAuthorizationToken: Bool { get }
    func decode(_ data: Data) throws -> Output
    func decodeError(_ data: Data) throws -> ErrorResponseDto
}

extension Request {
    func decodeError(_ data: Data) throws -> ErrorResponseDto {
        let decoder = JSONDecoder()
        return try decoder.decode(ErrorResponseDto.self, from: data)
    }
}

extension Request where Output: Decodable {
    func decode(_ data: Data) throws -> Output {
        let decoder = JSONDecoder()
        return try decoder.decode(Output.self, from: data)
    }
}

extension Request {
    var addAuthorizationToken: Bool { true }
    var headers: [String: String]? { nil }
    var params: [String: Any]? { nil }
    var urlParams: [String: String?]? { nil }
    
    func createURLRequest(authToken: String?, environment: WebEnvironment) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "http"
        components.host = environment.host
        components.port = 8000
        components.path = environment.version + path
        
        if urlParams.isNotEmpty {
            components.queryItems = urlParams!.map { URLQueryItem(name: $0, value: $1) }
        }
        
        guard let url = components.url else { throw  NetworkError.invalidURL }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        
        if headers.isNotEmpty {
            urlRequest.allHTTPHeaderFields = headers
        }
        
        if addAuthorizationToken {
            if authToken.isNilOrEmptyIncludingWhitespaces {
                throw NetworkError.missingToken
            }
            urlRequest.setValue("Bearer " + authToken!, forHTTPHeaderField: "Authorization")
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(Locale.languageTag, forHTTPHeaderField: "Accept-Language")
        
        if params.isNotEmpty {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params!)
        }
        
        return urlRequest
    }
}
