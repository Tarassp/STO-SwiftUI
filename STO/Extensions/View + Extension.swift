//
//  View + Extension.swift
//  STO
//
//  Created by Taras Spasibov on 10.06.2022.
//

import SwiftUI

extension View {
    func errorAlert(error: Binding<ErrorMessage?>, buttonTitle: String = "OK") -> some View {
        let localized = error.wrappedValue
        return alert(localized?.title ?? "", isPresented: .constant(localized.isNotNil), actions: {
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        }, message: {
            Text(localized?.message ?? "")
        })
    }
}
