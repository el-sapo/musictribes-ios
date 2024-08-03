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
    let addEmboss: Bool

    init(emboss: Bool = true) {
        self.addEmboss = emboss
    }

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
                }
                .if(addEmboss) { view in
                    view
                        .layerEffect(ShaderLibrary.emboss(.float(0.3)), maxSampleOffset: .zero)
                }
        }
    }
}


struct TextAnimated: View {
    @State private var start = Date.now

    var body: some View {
        TimelineView(.animation) { tl in
            let time = start.distance(to: tl.date)
            Text("logo-small")
                .colorEffect(ShaderLibrary.glowCustom(.float(time)))
        }
    }
}
