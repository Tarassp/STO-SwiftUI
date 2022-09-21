//
//  DefaultKeychain.storage.swift
//  STO
//
//  Created by Taras Spasibov on 10.06.2022.
//

import Foundation
import Combine
import KeychainAccess

public final class DefaultKeychainStorage: KeychainStorage {
    
    static let shared = DefaultKeychainStorage()
    private let keychain = Keychain()
        .label("DefaultKeychainStorage")
        .synchronizable(true)
    
    private init() {}
    
    public func set<T: Codable>(_ value: T, forKey key: KeychainKey) -> AnyPublisher<T, Error> {
        Future { promise in
            do {
                let data = try JSONEncoder().encode(value)
                try self.keychain.set(data, key: key.rawValue)
                promise(.success(value))
            } catch {
                promise(.failure(KeychainError.invalidSetValue))
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func value<T: Codable>(forKey key: KeychainKey) -> AnyPublisher<T?, Error> {
        Future { promise in
            do {
                if let data = try self.keychain.getData(key.rawValue) {
                    let value = try JSONDecoder().decode(T.self, from: data)
                    promise(.success(value))
                } else {
                    promise(.success(nil))
                }
            } catch {
                promise(.failure(KeychainError.invalideGetValue))
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func removeObject(forKey key: KeychainKey) -> AnyPublisher<Void, Error> {
        Future { promise in
            do {
                try self.keychain.remove(key.rawValue)
                promise(.success(()))
            }
            catch {
                promise(.failure(KeychainError.invalidDeleteValue))
            }
        }
        .eraseToAnyPublisher()
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
}
