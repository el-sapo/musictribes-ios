//
//  CollectedItem.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 28/5/24.
//

import Foundation

struct CollectedItem: Codable, Hashable {
    let image: String
    let title: String
    let description: String?
    let sourceUrl: String

    static func == (lhs: CollectedItem, rhs: CollectedItem) -> Bool {
        return lhs.image == rhs.image && lhs.title == rhs.title && lhs.description == rhs.description && lhs.sourceUrl == rhs.sourceUrl
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(image)
        hasher.combine(title)
        hasher.combine(description)
        hasher.combine(sourceUrl)
    }
}
