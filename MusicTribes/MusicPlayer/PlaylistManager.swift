//
//  PlaylistManager.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 25/10/24.
//

import Foundation

class PlaylistManager {
    static let shared = PlaylistManager()

    private let playlistsKey = "playlists"

    func savePlaylist(_ playlist: [Song], withName name: String) {
        // Convert playlist to a storable format (e.g., array of dictionaries)
        let playlistData = playlist.map { ["title": $0.title, "artist": $0.artist, "url": $0.songUrl] }
        UserDefaults.standard.set(playlistData, forKey: playlistsKey + name)
    }

    func loadPlaylist(withName name: String) -> [Song]? {
        guard let playlistData = UserDefaults.standard.array(forKey: playlistsKey + name) as? [[String: String]] else {
            return nil
        }

        return nil// playlistData.map { Song(title: $0["title"]!, artist: $0["artist"]!, songUrl: $0["url"]!) }
    }
}
