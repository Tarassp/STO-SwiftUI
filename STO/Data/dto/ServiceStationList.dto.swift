//
//  ServiceStationList.dto.swift
//  STO
//
//  Created by Taras Spasibov on 28.06.2022.
//

import Foundation

struct ServiceStationListDto: Codable {
    let items: [ServiceStationDto]
    let count: Int
}
