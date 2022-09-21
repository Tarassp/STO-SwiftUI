//
//  SignedInDependencyContainer.swift
//  STO
//
//  Created by Taras Spasibov on 22.06.2022.
//

import Combine

struct SignedInDependencyContainer {
    
    // MARK: - From parent container
    let appState: Store<AppState>
    
    init(appState: Store<AppState>) {
        self.appState = appState
    }
    
    @MainActor
    func makeMainView() -> MainView {
        let viewModel = MainView.ViewModel(appState: appState, reSignInManager: DefaultReSignInManager.shared)
        return MainView(viewModel: viewModel, factoryView: self)
    }
    
    func makeProfileView() -> ProfileView {
        let viewModel = ProfileView.ViewModel(appState: appState)
        return ProfileView(viewModel: viewModel)
    }
}

extension SignedInDependencyContainer: MainViewFactory {
    @MainActor
    func makeSignInView() -> SignInView {
        let service = makeGetUserSessionService()
        let viewModel = SignInView.ViewModel(appState: appState, getUserSessionService: service)
        return SignInView(viewModel: viewModel)
    }
}

// MARK: - Services
extension SignedInDependencyContainer {
    func makeGetUserSessionService() -> GetUserSessionService {
        DefaultGetUserSessionService()
    }
}
