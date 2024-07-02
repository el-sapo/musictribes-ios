//
//  LoaderView.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 26/6/24.
//

import SwiftUI

struct LoaderView: View {
    @State private var start = Date.now
    var body: some View {
        ZStack {
            BackgroundMesh()
            TimelineView(.animation) { tl in
                let time = start.distance(to: tl.date)
                Image("logo-small")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.customGreen)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200.0)
                    .colorEffect(ShaderLibrary.glowFire(.float(time)))
                    .layerEffect(ShaderLibrary.emboss(.float(0.3)), maxSampleOffset: .zero)
                
            }
        }.edgesIgnoringSafeArea(.all)
            .statusBar(hidden: true)

    }
}

#Preview {
    LoaderView()
}
