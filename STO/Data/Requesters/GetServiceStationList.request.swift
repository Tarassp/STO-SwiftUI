//
//  GetServiceStationList.request.swift
//  STO
//
//  Created by Taras Spasibov on 28.06.2022.
//

import Foundation

struct GetServiceStationListRequest: Request {
    typealias Output = ServiceStationListDto
    
    let path = "/api/service-station/list"
    let httpMethod: HTTPMethod = .get
}
