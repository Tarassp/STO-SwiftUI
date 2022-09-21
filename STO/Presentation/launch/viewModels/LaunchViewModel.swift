//
//  LaunchViewModel.swift
//  STO
//
//  Created by Taras Spasibov on 03.06.2022.
//

import Combine
import Foundation

extension LaunchView {
    struct Routing: Equatable {
        var authorizationFlowState: State = .signedOut
    }
    
    enum State: Equatable {
        case signedIn
        case signedOut
    }
}

extension LaunchView {
    
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var routing: Routing
        
        private var subscriptions = Set<AnyCancellable>()
        
        init(appState: Store<AppState>, getUserSessionService: GetUserSessionService) {
            
            routing = appState[\.routing.launchFlow]
            
            $routing
                .removeDuplicates()
                .print()
                .sink { appState[\.routing.launchFlow] = $0 }
                .store(in: &subscriptions)
            
            appState
                .map(\.routing.launchFlow)
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .assign(to: &$routing)
            
            getUserSessionService
                .outputs
                .map { $0.isNotNil ? State.signedIn : State.signedOut }
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { state in
                    self.routing.authorizationFlowState = state
                })
                .store(in: &subscriptions)
            
            getUserSessionService
                .read()
        }
        
        deinit {
            print("\(type(of: self)): \(#function)")
        }
    }
}
