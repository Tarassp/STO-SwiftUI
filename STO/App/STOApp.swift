//
//  STOApp.swift
//  STO
//
//  Created by Taras Spasibov on 31.05.2022.
//

import SwiftUI

@main
struct STOApp: App {
    private let injectionContainer = AppDependencyContainer(appState: AppState())
    
    var body: some Scene {
        WindowGroup {
            injectionContainer.makeLaunchView()
        }
    }
}
