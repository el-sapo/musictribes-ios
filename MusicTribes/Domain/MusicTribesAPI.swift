//
//  MusicTribesAPI.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 22/5/24.
//

import Foundation
import Combine

final class MusicTribesAPI {
 
    func artistsFromUser(user: String) -> AnyPublisher<[CollectedArtist], Error> {
        return Future<[CollectedArtist], Error> { promise in
            promise(.success(MockData.collectedArtists)
            )
        }.eraseToAnyPublisher()
    }
}
