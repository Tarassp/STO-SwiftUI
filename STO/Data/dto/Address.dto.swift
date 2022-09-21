//
//  Address.dto.swift
//  STO
//
//  Created by Taras Spasibov on 28.06.2022.
//

import Foundation

struct AddressDto: Codable {
    let country: String
    let city: String
    let state: String
    let zip: String
    let addressLine1: String
    let addressLine2: String?
}
