//
//  UserProfile.entity.swift
//  STO
//
//  Created by Taras Spasibov on 02.06.2022.
//

import Foundation

public struct UserProfile: Codable, Equatable {
    
    // MARK: - Properties
    public let firstName: String
    public let lastName: String
    public let email: String
//    public let mobileNumber: String?
//    public let avatar: URL?
    
    // MARK: - Methods
    public init(firstName: String, lastName: String, email: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
//        self.mobileNumber = mobileNumber
//        self.avatar = avatar
    }
}
