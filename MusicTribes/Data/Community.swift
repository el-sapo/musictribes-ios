//
//  Community.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 2/8/24.
//
import SwiftUI

struct Community {
    let title: String
    let cover: String
    let color: Color
    let collectedItems: [CollectedArtist]

    init(title: String, cover: String = "", color: Color = .customGreen, collectedItems: [CollectedArtist]) {
        self.title = title
        self.cover = cover
        self.color = color
        self.collectedItems = collectedItems
    }

    func crateItems() -> [CrateItem] {
        return self.collectedItems.map { artist in
            return CrateItem(
                artist: artist,
                song: artist.collectedItems.first ?? CollectedItem(image: "", title: "", description: "", sourceUrl: "")
            )
        }
    }
}
