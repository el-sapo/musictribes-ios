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
    case scenes
}

struct DataConstants {
    static let mtApiKey = "0b1b7080-0fe9-4b1e-b2d8-5879c46f9d03"
}

class DataManager {
    static func dataForType(_ dataType: DataType = .mixtape) -> Future<[CollectedArtist], Error> {
        return Future { promise in
            DispatchQueue.global().async {
                let collectedArtists = jsonFileForDataType(dataType)
                promise(.success(collectedArtists))
            }
        }
    }
}

func jsonFileForDataType(_ dataType: DataType = .mixtape) -> [CollectedArtist] {
    var collectedArtists: [CollectedArtist] = []
    switch dataType {
    case .mixtape:
        collectedArtists = loadJSONFromMixtapeFile(fileName: "danc3-songs") ?? []
    case .scenes:
        collectedArtists = loadJSONFromMixtapeFile(fileName: "scenes") ?? []
    }
    return collectedArtists
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

    // Convert data to string to print it
    if let jsonString = String(data: data, encoding: .utf8) {
        print("Loaded JSON data:\n\(jsonString)")
    } else {
        print("Failed to convert data to string.")
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
