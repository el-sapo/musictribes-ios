//
//  DataManager.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 6/7/24.
//

import Foundation
import Combine

enum DataType {
    case mixtape
}

class DataManager {
    static func dataForType(_ dataType: DataType = .mixtape) -> Future<[CollectedArtist], Error> {
        return Future { promise in
            DispatchQueue.global().async {
                guard let collectedArtists = loadJSONFromMixtapeFile(fileName: "danc3-songs") else {
                    promise(.failure(
                        NSError(domain: "",
                                code: -1,
                                userInfo: [NSLocalizedDescriptionKey: "Failed to locate file in bundle."]
                               )))
                    return
                }
                promise(.success(collectedArtists))
            }
        }
    }
}




func loadJSONFromMixtapeFile(fileName: String) -> [CollectedArtist]? {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
        print("Failed to locate file in bundle.")
        return nil
    }
    
    guard let data = try? Data(contentsOf: url) else {
        print("Failed to load data from file.")
        return nil
    }
    
    let decoder = JSONDecoder()
    guard let rawArtists = try? decoder.decode([MixtapeData].self, from: data) else {
        print("Failed to decode JSON data.")
        return nil
    }
    
    // Map the raw data to the CollectedArtist structure
    let collectedArtists = rawArtists.map { rawArtist -> CollectedArtist in
        let collectedItem = CollectedItem(
            image: rawArtist.cover,
            title: rawArtist.title,
            description: rawArtist.description,
            sourceUrl: rawArtist.url
        )
        return CollectedArtist(
            contract: rawArtist.contract,
            name: rawArtist.artist,
            collectedNumber: "",
            collectedItems: [collectedItem]
        )
    }
    
    return collectedArtists
}


// Define a structure that mirrors the JSON data
struct MixtapeData: Codable {
    let artist: String
    let avatar: String
    let title: String
    let cover: String
    let description: String?
    let contract: String
    let url: String
}
