//
//  ErrorMessage.swift
//  STO
//
//  Created by Taras Spasibov on 02.06.2022.
//

import Foundation

public struct ErrorMessage: LocalizedError {

    // MARK: - Properties
    let code: Int
    let title: String
    let message: String?

    // MARK: - Methods
    init(title: String, message: String?, code: Int = -1) {
        self.code = code
        self.title = title
        self.message = message
    }
    
    init() {
        self.code = -1
        self.title = ""
        self.message = nil
    }
}
