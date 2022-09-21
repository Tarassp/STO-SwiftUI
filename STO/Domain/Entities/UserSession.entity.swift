//
//  UserSession.entity.swift
//  STO
//
//  Created by Taras Spasibov on 02.06.2022.
//

import Foundation

public class UserSession: Codable {
    
    // MARK: - Properties
    public let profile: UserProfile
    public let remoteSession: UserToken
    
    // MARK: - Methods
    public init(profile: UserProfile, remoteSession: UserToken) {
        self.profile = profile
        self.remoteSession = remoteSession
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
}

extension UserSession: Equatable {
    
    public static func ==(lhs: UserSession, rhs: UserSession) -> Bool {
        return lhs.profile == rhs.profile && lhs.remoteSession == rhs.remoteSession
    }
}
