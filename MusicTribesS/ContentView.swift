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
            let isNotLoading = Binding<Bool>(
                        get: { !isLoading },
                        set: { isLoading = !$0 }
                    )
            CommunityHomeView(isVisible: isNotLoading)
            if isLoading {
                LoaderView()
                    .transition(.opacity)
            }
        }
    }
}

#Preview {
    ContentView()
}
