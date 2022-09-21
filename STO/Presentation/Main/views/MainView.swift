//
//  MainView.swift
//  STO
//
//  Created by Taras Spasibov on 16.06.2022.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject private var viewModel: ViewModel
    private let factoryView: MainViewFactory?
    
    init(viewModel: ViewModel, factoryView: MainViewFactory?) {
        self.viewModel = viewModel
        self.factoryView = factoryView
    }
    
    var body: some View {
        TabView(selection: $viewModel.routing.selectedTab) {
            HomeView()
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }
                .tag(TabItem.home)
            
            Text("ORDER")
                .tabItem {
                    Label("Order", systemImage: "square.and.pencil")
                }
                .tag(TabItem.order)
            
            factoryView?
                .makeProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
                .tag(TabItem.profile)
        }
        .sheet(isPresented: $viewModel.routing.isUnauthorized, onDismiss: {
            print("DISMIESSED")
        }, content: {
            factoryView?.makeSignInView()
        })
    }
}

protocol MainViewFactory {
    func makeSignInView() -> SignInView
    func makeProfileView() -> ProfileView
}

struct MainView_Previews: PreviewProvider {
    
    static var viewModel: MainView.ViewModel {
        .init(appState: appState, reSignInManager: DefaultReSignInManager.shared)
    }
    
    static var previews: some View {
        MainView(viewModel: viewModel, factoryView: nil)
    }
}
