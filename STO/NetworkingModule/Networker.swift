//
//  Networker.swift
//  STO
//
//  Created by Taras Spasibov on 01.06.2022.
//

import Foundation
import os
import Combine

public protocol Networking {
    func perform<R: Request>(_ request: R, authToken: String?) -> AnyPublisher<R.Output, Error>
}

public class Networker: Networking {
    private let urlSession: URLSession
    private let environment = WebEnvironment.development
    
    private let logger = Logger(
            subsystem: Bundle.main.bundleIdentifier!,
            category: String(describing: Networker.self))
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    public func perform<R: Request>(_ request: R, authToken: String? = nil) -> AnyPublisher<R.Output, Error> {
        do {
            let urlRequest = try request.createURLRequest(authToken: authToken, environment: environment)
            logger.trace("\(NetworkInfoGenerator.request(urlRequest))")
            return urlSession
                .dataTaskPublisher(for: urlRequest)
                .handleEvents(receiveOutput: { [weak self] data, response in
                    self?.logger.trace("\(NetworkInfoGenerator.response(urlRequest, response, data))")
                })
                .tryMap { data, response in
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw NetworkError.invalidServerResponse
                    }
                    
                    switch httpResponse.statusCode {
                    case (200..<300): return try request.decode(data)
                    case 401: throw NetworkError.unauthorized
                    default:
                        let dto = try request.decodeError(data)
                        throw NetworkError.resposeError(dto)
                    }
                }
                .share()
                .eraseToAnyPublisher()
        } catch {
            if let networkError = error as? NetworkError {
                logger.error("\(networkError.message)")
            }
            return Fail(outputType: R.Output.self, failure: error).eraseToAnyPublisher()
        }
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
}
