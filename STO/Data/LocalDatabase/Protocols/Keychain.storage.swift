//
//  Keychain.storage.swift
//  STO
//
//  Created by Taras Spasibov on 07.06.2022.
//

import Foundation
import Combine

public protocol KeychainStorage {
    func set<T: Codable>(_ value: T, forKey key: KeychainKey) -> AnyPublisher<T, Error>
    func value<T: Codable>(forKey key: KeychainKey) -> AnyPublisher<T?, Error>
    func removeObject(forKey key: KeychainKey) -> AnyPublisher<Void, Error>
}

public enum KeychainKey: String {
    case userToken
    case userSession
}

public enum KeychainError: LocalizedError {
    case invalidSetValue
    case invalideGetValue
    case invalidDeleteValue
    
    public var message: String {
        switch self {
        case .invalidSetValue:
            return "Can't save value into Keychain"
        case .invalideGetValue:
            return "Can't get value from Keychain"
        case .invalidDeleteValue:
            return "Can't delete value from Keychain"
        }
    }
}
