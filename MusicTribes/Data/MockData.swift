//
//  MockData.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 17/5/24.
//

import Foundation

struct MockData {
    static let collectedArtists = [
        CollectedArtist(contract:"1" ,name: "Sound of Fractures", collectedNumber: "105"),
        CollectedArtist(contract:"2" ,name: "Daniel Allan", collectedNumber: "45"),
        CollectedArtist(contract:"3" ,name: "Xcelencia", collectedNumber: "89"),
        CollectedArtist(contract:"4" ,name: "Jadyn Violet", collectedNumber: "30"),
        CollectedArtist(contract:"5" ,name: "Vivid Fever Dreams", collectedNumber: "8"),
        CollectedArtist(contract:"6" ,name: "Bloody", collectedNumber: "1000"),
    ]
    
    static let collectedItems = [
        CollectedItem(image: "mt-bw", title: "song title", description: "collected song description", sourceUrl: ""),
        CollectedItem(image: "album-1", title: "song title", description: "collected song description", sourceUrl: ""),
        CollectedItem(image: "pfp", title: "song title", description: "collected song description", sourceUrl: "")
    ]
    
}
