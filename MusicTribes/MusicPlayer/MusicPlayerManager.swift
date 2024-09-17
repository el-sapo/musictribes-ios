//
//  MusicPlayerManager.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 16/9/24.
//

import Foundation
import AVFoundation
import Combine

final class MusicPlayerManager: ObservableObject {
    static let shared = MusicPlayerManager()

    @Published var isPlaying: Bool = false
    @Published var currentSong: PlaySong? = nil
    @Published var playbackProgress: Double = 0.0

    private var player: AVPlayer?
    private var currentQueue: [PlaySong] = []
    private var currentIndex: Int = 0

    private var playbackObserver: AnyCancellable?

    private init() {}

    // Add song to queue
    func addToQueue(_ song: PlaySong, play: Bool = false) {
        if play {
            currentQueue.insert(song, at: 0)
            playSong(at: 0)
        } else {
            currentQueue.append(song)
        }
    }

    // Play a song from the queue
    func playSong(at index: Int) {
        guard index >= 0 && index < currentQueue.count else { return }

        let song = currentQueue[index]
        currentSong = song
        currentIndex = index
        play(song: song)
    }

    private func play(song: PlaySong) {
        guard let url = URL(string: song.songUrl) else { return } // In future, handle local files

        player = AVPlayer(url: url)
        player?.play()
        isPlaying = true

        // Observe playback progress
        playbackObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { [weak self] time in
            guard let self = self, let duration = self.player?.currentItem?.duration.seconds else { return }
            let currentTime = time.seconds
            self.playbackProgress = currentTime / duration
        } as? AnyCancellable
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    func resume() {
        player?.play()
        isPlaying = true
    }

    func next() {
        guard currentIndex + 1 < currentQueue.count else { return }
        playSong(at: currentIndex + 1)
    }

    func previous() {
        guard currentIndex - 1 >= 0 else { return }
        playSong(at: currentIndex - 1)
    }
}
