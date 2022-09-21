//
//  String + Extension.swift
//  STO
//
//  Created by Taras Spasibov on 06.06.2022.
//

import Foundation

public extension String {
    var isEmptyOrWhitespace: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isNotEmptyOrWhitespace: Bool {
        !isEmptyOrWhitespace
    }
}
