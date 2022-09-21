//
//  ProfileViewModel.swift
//  STO
//
//  Created by Taras Spasibov on 24.06.2022.
//

import Foundation
import Combine

//extension ProfileView {
//    struct Routing: Equatable {
//        var isUnauthorized = false
//    }
//}

extension ProfileView {
    final class ViewModel: ObservableObject {
        
        private let signOutService: SignOutService
        private var subscriptions = Set<AnyCancellable>()
        
        @Published var error: ErrorMessage?
        
        init(appState: Store<AppState>, signOutService: SignOutService = DefaultSignOutService()) {
            self.signOutService = signOutService
            
            signOutService
                .outputs
                .sink(receiveValue: {
                    appState[\.routing.launchFlow.authorizationFlowState] = .signedOut
                })
                .store(in: &subscriptions)
            
            signOutService
                .error
                .map { $0 }
                .receive(on: DispatchQueue.main)
                .assign(to: &$error)
        }
        
        func signOut() {
            signOutService.execute()
        }
        deinit {
            print("\(type(of: self)): \(#function)")
        }
    }
}
