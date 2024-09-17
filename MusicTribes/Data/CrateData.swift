//
//  CrateData.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 29/7/24.
//

import Foundation

struct CrateItem {
    let artist: CollectedArtist
    let song: CollectedItem

    func songToPlay() -> PlaySong {
        PlaySong(artist: artist.name, title: song.title, coverImage: song.image, songUrl: song.sourceUrl)
    }
}

