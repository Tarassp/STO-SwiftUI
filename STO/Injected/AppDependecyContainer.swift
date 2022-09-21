//
//  AppDependecyContainer.swift
//  STO
//
//  Created by Taras Spasibov on 21.06.2022.
//

import SwiftUI
import Combine

struct AppDependencyContainer {
    
    let appState: Store<AppState>
    
    init(appState: Store<AppState>) {
        self.appState = appState
    }
    
    init(appState: AppState) {
        self.init(appState: Store(appState))
    }
    
    @MainActor
    func makeLaunchView() -> LaunchView {
        let service = makeGetUserSessionService()
        let viewModel = LaunchView.ViewModel(appState: appState, getUserSessionService: service)
        return LaunchView(viewModel: viewModel, factoryView: self)
    }
    
    func makeSignedInDependencyContainer() -> SignedInDependencyContainer {
        SignedInDependencyContainer(appState: appState)
    }
}

// MARK: - Services
extension AppDependencyContainer {
    func makeGetUserSessionService() -> GetUserSessionService {
        DefaultGetUserSessionService()
    }
}

extension AppDependencyContainer: LaunchViewFactory {
    @MainActor
    func makeSignInView() -> SignInView {
        let service = makeGetUserSessionService()
        let viewModel = SignInView.ViewModel(appState: appState, getUserSessionService: service)
        return SignInView(viewModel: viewModel)
    }
    
    @MainActor
    func makeMainView() -> MainView {
        let dependencyContainer = makeSignedInDependencyContainer()
        return dependencyContainer.makeMainView()
    }
}
