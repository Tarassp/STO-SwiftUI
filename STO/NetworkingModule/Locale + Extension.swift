//
//  Locale + Extension.swift
//  STO
//
//  Created by Taras Spasibov on 20.06.2022.
//

import Foundation

extension Locale {
    static var languageTag: String {
        let lCode = current.languageCode ?? "en"
        let rCode = current.regionCode ?? "US"
        return lCode + "-" + rCode
    }
}
