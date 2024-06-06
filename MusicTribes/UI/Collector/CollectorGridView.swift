//
//  CollectorGridView.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 17/5/24.
//

import SwiftUI

struct CollectorGridView: View {
//    let columns: [GridItem] = Array(repeating: GridItem(.flexible(minimum:150)), count: 2)
    let columns: [GridItem] = [GridItem(.adaptive(minimum: 150, maximum: 300))]
    let screenSize = UIScreen.main.bounds

    let gridData: [CollectedArtist]
    let gridSeparation = 20.0
    
    var body: some View {
            ScrollView {
                GeometryReader { geometry in
                LazyVGrid(columns: columns, spacing: 20, pinnedViews: .sectionHeaders ,content: {
                    Section {
                        ForEach(gridData) { crate in
                            CollectorItemCrateView(collectorCrate: crate, collectionCrateItems: MockData.collectedItems)
                                .frame(
                                    width: ((geometry.size.width / 2) - gridSeparation),
                                    height: geometry.size.width / 2 + 40.0
                                )
                        }
                    } header: {
                        Text("")
                    }
                })
            }
        }
    }
}

#Preview {
    CollectorGridView(
        gridData: MockData.collectedArtists
    )
}
