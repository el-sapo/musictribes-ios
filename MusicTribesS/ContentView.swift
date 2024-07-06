//
//  ContentView.swift
//  MusicTribesS
//
//  Created by Federico Lagarmilla on 16/6/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = HomeViewModel()

    // add view model to handle hiding the loader
    var body: some View {
        ZStack {
            CommunityHomeView()
                .environmentObject(vm)
            if vm.loading {
                LoaderView()
                    .transition(.opacity)
            }
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    vm.showLoader(false)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

class HomeViewModel: ObservableObject {
    @Published var loading: Bool = true
    
    func showLoader(_ show:Bool, animated: Bool = true) {
        loading = show
    }
}
