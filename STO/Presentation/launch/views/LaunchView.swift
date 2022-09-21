//
//  LaunchView.swift
//  STO
//
//  Created by Taras Spasibov on 03.06.2022.
//

import SwiftUI

struct LaunchView: View {
    @ObservedObject private var viewModel: ViewModel
    private let factoryView: LaunchViewFactory?
    
    init(viewModel: ViewModel, factoryView: LaunchViewFactory?) {
        self.viewModel = viewModel
        self.factoryView = factoryView
    }
    
    var body: some View {
        switch viewModel.routing.authorizationFlowState {
        case .signedIn: factoryView?.makeMainView()
        case .signedOut: factoryView?.makeSignInView()
        }
    }
}

protocol LaunchViewFactory {
    func makeSignInView() -> SignInView
    func makeMainView() -> MainView
}

struct LaunchView_Previews: PreviewProvider {
    
    static var previews: some View {
        LaunchView(viewModel: LaunchView.ViewModel(appState: appState, getUserSessionService: DefaultGetUserSessionService()), factoryView: nil)
    }
}


extension PreviewProvider {
    static var appState: Store<AppState> {
        Store(AppState())
    }
}
