//
//  ProfileView.swift
//  STO
//
//  Created by Taras Spasibov on 24.06.2022.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ViewModel
    
    
    var body: some View {
        Button("Sign Out") {
            viewModel.signOut()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileView.ViewModel(appState: appState))
    }
}
