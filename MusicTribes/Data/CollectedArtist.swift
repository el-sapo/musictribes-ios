//
//  CollectedArtist.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 17/5/24.
//

import Foundation

struct CollectedArtist: Hashable, Identifiable {
    let id = UUID()
    let contract: String
    let name: String
    let collectedNumber: String
    var collectedItems: [CollectedItem] = []

    static func == (lhs: CollectedArtist, rhs: CollectedArtist) -> Bool {
        return lhs.contract == rhs.contract && lhs.name == rhs.name && lhs.collectedNumber == rhs.collectedNumber && lhs.collectedItems == rhs.collectedItems
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(contract)
        hasher.combine(name)
        hasher.combine(collectedNumber)
        hasher.combine(collectedItems)
    }

    func crateItems() -> [CrateItem] {
        return self.collectedItems.map { song in
            CrateItem(artist: self, song: song)
        }
    }
}


