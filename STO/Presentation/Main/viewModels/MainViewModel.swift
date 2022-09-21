//
//  MainViewModel.swift
//  STO
//
//  Created by Taras Spasibov on 22.06.2022.
//

import Foundation
import Combine

extension MainView {
    struct Routing: Equatable {
        var isUnauthorized = false
        var selectedTab: TabItem = .home
    }
    
    enum TabItem {
        case home
        case order
        case profile
    }
}


extension MainView {
    
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var routing: Routing
        
        private var subscriptions = Set<AnyCancellable>()
        
        init(appState: Store<AppState>, reSignInManager: ReSignInManager) {
            routing = appState[\.routing.mainFlow]
            
            $routing
                .removeDuplicates()
                .sink { appState[\.routing.mainFlow] = $0 }
                .store(in: &subscriptions)
            
            appState
                .map(\.routing.mainFlow)
                .receive(on: DispatchQueue.main)
                .removeDuplicates()
                .assign(to: &$routing)
            
            reSignInManager
                .reSignInIsNeeded
                .receive(on: DispatchQueue.main)
                .sink {
                    self.routing.isUnauthorized = $0
                }
                .store(in: &subscriptions)
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
//                TestRepository()
//                    .test()
//                    .sink(receiveCompletion: { _ in
//
//                    }, receiveValue: {
//                        print("REC VALUE")
//                    })
//                    .store(in: &self.subscriptions)
//            }
        }
        
        deinit {
            print("\(type(of: self)): \(#function)")
        }
    }
    
}
