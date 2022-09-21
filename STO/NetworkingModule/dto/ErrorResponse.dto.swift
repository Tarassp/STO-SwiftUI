//
//  ErrorResponse.dto.swift
//  STO
//
//  Created by Taras Spasibov on 16.06.2022.
//

import Foundation

public struct ErrorResponseDto: Codable {
    let code: Int
    let message: String
}
