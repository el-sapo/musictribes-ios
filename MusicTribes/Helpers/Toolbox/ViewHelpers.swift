//
//  ViewHelpers.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 2/7/24.
//

import SwiftUI

struct LogoView: View {
    @State private var start = Date.now
    let animateLogo: Bool = true

    var body: some View {
        TimelineView(.animation) { tl in
            let time = start.distance(to: tl.date)
            Image("logo-small")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(.customGreen)
                .aspectRatio(contentMode: .fit)
                .if(animateLogo) { view in
                    view
                        .colorEffect(ShaderLibrary.glowFire(.float(time)))
                        .layerEffect(ShaderLibrary.emboss(.float(0.3)), maxSampleOffset: .zero)
                }
        }
    }
}
