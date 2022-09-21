//
//  SignInViewModel.swift
//  STO
//
//  Created by Taras Spasibov on 03.06.2022.
//

import Combine
import Foundation

extension SignInView {
    
    @MainActor
    final class ViewModel: ObservableObject {
        private let getUserSessionService: GetUserSessionService
        private var subscriptions = Set<AnyCancellable>()
        
        @Published var email = ""
        @Published var password = ""
        @Published var error: ErrorMessage?
        
        init(appState: Store<AppState>, getUserSessionService: GetUserSessionService) {
            self.getUserSessionService = getUserSessionService
            
            getUserSessionService
                .outputs
                .unwrap()
                .sink(receiveValue: { _ in
                    if appState[\.routing.mainFlow.isUnauthorized] {
                        appState[\.routing.mainFlow.isUnauthorized] = false
                    } else {
                        appState[\.routing.launchFlow.authorizationFlowState] = .signedIn
                    }
                })
                .store(in: &subscriptions)
            
            getUserSessionService
                .error
                .map { $0 }
                .receive(on: DispatchQueue.main)
                .assign(to: &$error)
        }
        
        func signIn() {
            getUserSessionService.fetch(email: email, password: password)
        }
        
        deinit {
            print("\(type(of: self)): \(#function)")
        }
    }
    
}
