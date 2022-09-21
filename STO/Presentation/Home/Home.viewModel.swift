//
//  Home.viewModel.swift
//  STO
//
//  Created by Taras Spasibov on 16.06.2022.
//

import Combine
import Foundation

final class HomeViewModel: ObservableObject {
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 15, execute: {
//            TestRepository()
//                .test()
//                .bind(onSuccess: {
//                    print("VOIDDDDDD")
//                }, onError: { error in
//                    print(error.message ?? "")
//                })
//                .store(in: &self.subscriptions)
//        })
    }
    
    func signOut() {
//        getUserSessionService.fetch(email: email, password: password)
        
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
}
