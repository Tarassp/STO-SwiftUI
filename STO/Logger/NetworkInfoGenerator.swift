//
//  NetworkInfoGenerator.swift
//  STO
//
//  Created by Taras Spasibov on 03.06.2022.
//

import Foundation

class NetworkInfoGenerator {
    static func request(_ urlRequest: URLRequest) -> String {
        var request = "\n====REQUEST=================================\n"

        if let method = urlRequest.httpMethod {
            request += "\(method)"

            if let url = urlRequest.url {
                request += " \(url.absoluteString) \n"
            } else {
                request += "\n"
            }
        }

        if let headers = urlRequest.allHTTPHeaderFields {
            for (header, value) in headers {
                request += "-H \"\(header): \(value)\" \\\n"
            }
        }

        if let body = urlRequest.httpBody, !body.isEmpty, let string = String(data: body, encoding: .utf8), !string.isEmpty {
            request += "-d '\(string)' \\\n"
        }

        request += "============================================"

        return request
    }
    
    static func response(_ urlRequest: URLRequest, _ urlResponse: URLResponse?, _ data: Data) -> String {
        let httpUrlResponse = urlResponse as? HTTPURLResponse
        let statusCode = httpUrlResponse?.statusCode ?? 0
        var responseString = "\n====RESPONSE================================\n"
        if let method = urlRequest.httpMethod {

            responseString += "\(statusCode) \(method)"

            if let url = urlRequest.url {
                responseString += " \(url.absoluteString) \n"
            } else {
                responseString += "\n"
            }
        }
        if let headers = httpUrlResponse?.allHeaderFields {
            for (header, value) in headers {
                responseString += "-H \"\(header): \(value)\" \\\n"
            }
        }

        if  !data.isEmpty, let string = String(data: data, encoding: .utf8), !string.isEmpty {
            responseString += "-d '\(string)' \\\n"
        }

        responseString += "============================================"

        return responseString
    }
}
