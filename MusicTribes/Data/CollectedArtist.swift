//
//  CollectedArtist.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 17/5/24.
//

import Foundation

struct CollectedArtist: Hashable, Identifiable {
    let id = UUID()

    //var id: ObjectIdentifier
    
    let contract: String
    let name: String
    let collectedNumber: String
}
