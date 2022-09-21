//
//  SignInView.swift
//  STO
//
//  Created by Taras Spasibov on 02.06.2022.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var viewModel: ViewModel

    init(viewModel: ViewModel) {
      self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            TextField("Email", text: $viewModel.email)
            SecureField("Password", text: $viewModel.password)
                .textContentType(.password)
            Button("SIGN IN") {
                viewModel.signIn()
            }
        }
        .errorAlert(error: $viewModel.error)
    }
}

//struct SignInView_Previews: PreviewProvider {
//    
//    
//    static var previews: some View {
//        SignInView(viewModel: SignInViewModel(getUserSessionService: DefaultGetUserSessionService(), signedInResponder: nil) )
//    }
//}
