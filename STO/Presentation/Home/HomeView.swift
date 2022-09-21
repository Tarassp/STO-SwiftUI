//
//  HomeView.swift
//  STO
//
//  Created by Taras Spasibov on 02.06.2022.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    
    var body: some View {
        Text("You are signed in!")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
