//
//  WebEnvironment.swift
//  STO
//
//  Created by Taras Spasibov on 01.06.2022.
//

import Foundation

public enum WebEnvironment {
    case production
    case development
    case custom
}

extension WebEnvironment {
    public var host: String {
        switch self {
        case .production: return productionHost
        case .development: return developmentHost
        case .custom: return customHost
        }
    }
    
    public var version: String {
        "/v1"
    }
}

private extension WebEnvironment {
    var productionHost: String { "app" }
    var developmentHost: String { "127.0.0.1" }
    var customHost: String { "custom" }
}


