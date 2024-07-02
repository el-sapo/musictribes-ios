//
//  LoaderView.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 26/6/24.
//

import SwiftUI

struct LoaderView: View {
    var body: some View {
        ZStack {
            BackgroundMesh()
            LogoView()
                .frame(height: 200.0)
        }.edgesIgnoringSafeArea(.all)
            .statusBar(hidden: true)

    }
}

#Preview {
    LoaderView()
}
