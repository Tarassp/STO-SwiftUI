//
//  ServiceStation.dto.swift
//  STO
//
//  Created by Taras Spasibov on 28.06.2022.
//

import Foundation

struct ServiceStationDto: Codable {
    let id: String
    let name: String
    let worktime: WorktimeDto
    let address: AddressDto
    let rating: Double
}

extension ServiceStationDto {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, worktime, address, rating
    }
}
