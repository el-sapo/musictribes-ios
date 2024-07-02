//
//  ContentView.swift
//  MusicTribesS
//
//  Created by Federico Lagarmilla on 16/6/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoading: Bool = true

    var body: some View {
        ZStack {
            CommunityHomeView()
            if isLoading {
                LoaderView()
                    .transition(.opacity)
            }
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
