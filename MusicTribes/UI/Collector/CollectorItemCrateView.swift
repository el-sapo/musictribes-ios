//
//  CollectorCrateView.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 17/5/24.
//

import SwiftUI

struct CollectorCrateView: View {
    let collectorCrate: CollectedArtist
    
    var body: some View {
        VStack {
            Image(systemName: "album-1")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .aspectRatio(contentMode: .fill)
            Text(collectorCrate.name)
                .font(.headline)
                .fontWeight(.semibold)
                .scaledToFit()
                .minimumScaleFactor(0.5)
            Text("collected " + collectorCrate.collectedNumber)
                .fontWeight(.regular)
                .scaledToFit()
                .minimumScaleFactor(0.5)
        }
    }
}

#Preview {
    CollectorCrateView( 
        collectorCrate: CollectedArtist(
            contract: "",
            name: "Sound of Fractures",
            collectedNumber: "104"
        )
    )
}
