//
//  ErrorGenerator.swift
//  STO
//
//  Created by Taras Spasibov on 03.06.2022.
//

import Foundation

class ErrorMessageGenerator {
    static func generate(_ error: ErrorMessage) -> String {
"""
\n====ERROR===================================
TITLE: \(error.title)
MESSAGE: \(error.message ?? "No Message")
============================================
"""
    }
}
