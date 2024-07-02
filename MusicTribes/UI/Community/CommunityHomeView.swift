//
//  CommunityHomeView.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 17/6/24.
//

import SwiftUI

struct CommunityHomeView: View {
    let data = MockData.loadFromFile().first(where: { artist in
        return artist.name == "Sound of Fractures"
    })!

    let communityTitle = "DANC3 Mixtape"
    
    @State private var currentPage: Int = 0
    private let pageHeight: CGFloat = UIScreen.main.bounds.height
    
    @State var isVisible: Bool = false

    var body: some View {
        ZStack() {
            BackgroundMesh()
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    // add gradient animation with orange to the logo
                    Image("logo-small")
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 50.0)
                        .padding(.bottom, 30.0)
                        .opacity(0.7)
                    if isVisible {
                        Text("DANC3 Mixtape")
                            .customAttribute(EmphasisAttribute())
                            .myFont(style: .big, size: 32.0)
                            .scaledToFit()
                            .foregroundColor(.white)
                            .transition(TextTransition())
                    }
                    Spacer()
                        .frame(height: 20.0)
                    CollectorItemCrateView(
                        collectorCrate: data,
                        collectionCrateItems: data.collectedItems,
                        crateConfig: CrateViewConfig(
                            showTextTop: false,
                            showTextBottom: true,
                            showCount: false,
                            crateOffset: 20.0,
                            maxItems: 3
                        )
                    )
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.width
                    )
                    .background(Color.green)
                    .clipped()
                    ItemMenubar()
                        .frame(height: 40.0)
                    Spacer()
                }
                .frame(height: pageHeight)
                CommunityDetailView()
                    .frame(height: pageHeight)
                    .scrollTransition { content, phase in
                        content.opacity(phase.isIdentity ? 1.0 : 0.3 )
                    }

            }
            .contentMargins(.vertical, 44)
            .scrollTargetBehavior(.paging)
            VStack {
                Spacer()
                MusicPlayerView()
                    .opacity(0.0)
                Spacer()
                    .frame(height: 40.0)
            }
        }
        .onAppear {
            $isVisible.animation()
            isVisible = true
        }
    }
}

#Preview {
    CommunityHomeView()
}


