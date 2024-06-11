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
    
    static func loadFromFile() -> [CollectedArtist] {
        if let filePath = Bundle.main.path(forResource: "artists", ofType: "json") {
            do {
                // Read the file content
                let fileContent = try String(contentsOfFile: filePath, encoding: .utf8)
                
                // Convert the file content to Data
                if let jsonData = fileContent.data(using: .utf8) {
                    // Decode the JSON data
                    let songs = try JSONDecoder().decode([Song].self, from: jsonData)

                    // Print the decoded data
                    for song in songs {
                        print("Artist: \(song.artist), Title: \(song.title)")
                    }
                    
                    let artists = groupSongsByArtist(songs: songs)
                    return artists
                }
                return []
            } catch {
                print("An error occurred: \(error)")
                return []
            }
        } else {
            print("File not found.")
            return []
        }
    }
}

func groupSongsByArtist(songs: [Song]) -> [CollectedArtist] {
    // Create a dictionary to group songs by artistId
    var artistDictionary = [String: Set<Song>]()
    
    // Group songs by artistId
    for song in songs {
        if var existingSongs = artistDictionary[song.artistId] {
            existingSongs.insert(song)
            artistDictionary[song.artistId] = existingSongs
        } else {
            artistDictionary[song.artistId] = [song]
        }
    }
    
    // Map the grouped songs to CollectedArtist
    var collectedArtists = [CollectedArtist]()
    
    for (artistId, songs) in artistDictionary {
        let collectedItems = songs.map { song in
            CollectedItem(
                image: song.coverImage,
                title: song.title,
                description: song.description,
                sourceUrl: song.songUrl
            )
        }
        
        let collectedArtist = CollectedArtist(
            contract: artistId,
            name: songs.first?.artist ?? "",
            collectedNumber: "\(songs.count)",
            collectedItems: Array(collectedItems) // Ensure collectedItems is an array
        )
        

        // Sort collectedArtists by the number of songs in descending order
        collectedArtists.sort { $0.collectedNumber > $1.collectedNumber }
        collectedArtists.append(collectedArtist)
    }
    
    return collectedArtists
}

struct Song: Codable, Hashable {
    let artist: String
    let artistId: String
    let coverImage: String
    let title: String
    let description: String?
    let songUrl: String
    let webappUri: String
    let artistAvatarUrl: String
    let twitterHandle: String
    let instagramHandle: String
    let spotifyUrl: String
    let createdAtTime: String
}
