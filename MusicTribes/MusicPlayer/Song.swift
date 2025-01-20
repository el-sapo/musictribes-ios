//
//  Song.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 16/9/24.
//

struct Song: Codable, Hashable {
    let artist: String
    let artistId: String
    let coverImage: String
    let title: String
    let description: String?
    let songUrl: String
    let webappUri: String
    let artistAvatarUrl: String?
    let twitterHandle: String?
    let instagramHandle: String?
    let spotifyUrl: String?
    let createdAtTime: String
}

struct PlaySong: Identifiable {
    var id: String { songUrl }
    let artist: String
    let title: String
    let coverImage: String
    let songUrl: String
}
