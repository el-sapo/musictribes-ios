//
//  CollectorMainView.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 17/5/24.
//

import SwiftUI

struct CollectorMainView: View {
    @StateObject var vm: CollectorMainViewModel = CollectorMainViewModel()

    var body: some View {
        ZStack {
            CollectorGridView()
            VStack {
                Spacer()
                MusicPlayerView()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    CollectorMainView()
}


// this could be the title view
struct CollectorTitleView: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .scaledToFit()
                .minimumScaleFactor(0.5)
            Spacer()
        }
    }
}


class CollectorMainViewModel: ObservableObject {
    @Published var collectedArtistdata: [CollectedArtist] = []

    init() {
        loadCollectedArtistdata()
    }

    func loadCollectedArtistdata() {
        collectedArtistdata = MockData.loadFromFile()
    }
}
