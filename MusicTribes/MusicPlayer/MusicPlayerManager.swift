//
//  MusicPlayerManager.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 16/9/24.
//

import Foundation
import AVFoundation
import Combine
import MediaPlayer

final class MusicPlayerManager: ObservableObject {
    static let shared = MusicPlayerManager()

    enum PlayerType {
        case avPlayer, avAudioPlayer, none
    }

    @Published var isPlaying: Bool = false
    @Published var currentSong: PlaySong = PlaySong(artist: "", title: "", coverImage: "", songUrl: "")
    @Published var playbackProgress: Double = 0.0

    private var currentPlayerType: PlayerType = .none
    private var player: AVPlayer?
    private var audioPlayer: AVAudioPlayer?

    @Published var currentQueue: [PlaySong] = []
    @Published var currentIndex: Int = 0

    private var playbackObserver: AnyCancellable?
    private var nowPlayingInfoTimer: Timer?
    var mediaPlayingInfo: [String: Any]?

    private init() {
        observeEndOfPlayback()
    }

    // Add song to queue
    func addToQueue(_ song: PlaySong, play: Bool = false) {
        if play {
            currentQueue.insert(song, at: 0)
            playSong(at: 0)
        } else {
            currentQueue.append(song)
        }
        downloadSong(song)
    }

    func removeFromQueue(_ song: PlaySong, play: Bool = false) {
        if let index = currentQueue.firstIndex(where: { $0.songUrl == song.songUrl }) {
            currentQueue.remove(at: index)
        }
    }

    // Play a song from the queue
    func playSong(at index: Int) {
        guard index >= 0 && index < currentQueue.count else { return }

        let song = currentQueue[index]
        currentSong = song
        currentIndex = index
        play(song: song)

        updateMusicActivity(
                track: currentSong.title,
                artist: currentSong.artist,
                imageUrl: currentSong.coverImage
        )
    }

    func play(song: PlaySong? = nil) {
        var playSong = currentSong
        if let song = song {
            playSong = song
        }
        if playSong.songUrl.isEmpty {
            print("[MusicPlayerManager] There is no song to play")
            return
        }
        print("[MusicPlayerManager] Playing file \(playSong.title), (index: \(currentIndex))")

        removePlaybackObserver()

        currentSong = playSong
        if let localURL = localFilePath(for: playSong), FileManager.default.fileExists(atPath: localURL.path) {
            playLocalFile(url: localURL)
        } else if let remoteURL = URL(string: playSong.songUrl) {
            playRemoteFile(url: remoteURL)
        }
        setupNowPlayingInfo(for: playSong)
    }

    // Play local file with AVAudioPlayer
    private func playLocalFile(url: URL) {
        stopPlayback()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            print("[MusicPlayerManager] Playing local file")
            do {
                let audioPlayer = try AVAudioPlayer(contentsOf: url)
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.audioPlayer = audioPlayer
                    self.audioPlayer?.play()
                    self.isPlaying = true
                    self.currentPlayerType = .avAudioPlayer
                    self.startPlaybackObserver(for: self.audioPlayer)
                }
            } catch {
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    print("[MusicPlayerManager] Failed to play local file: \(error)")
                    self.removeFile(at: url)
                    if let remoteUrl = URL(string: self.currentSong.songUrl) {
                        self.playRemoteFile(url: remoteUrl)
                        self.setupNowPlayingInfo(for: self.currentSong)
                    }
                }
            }
        }
    }

    // Play remote file with AVPlayer
    private func playRemoteFile(url: URL) {
        stopPlayback()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            print("[MusicPlayerManager] Playing remote file \(url)")
            let player = AVPlayer(url: url)
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.player = player
                self.player?.play()
                self.isPlaying = true
                self.currentPlayerType = .avPlayer
                self.startPlaybackObserver(for: self.player)
            }
        }
    }

    // Observe playback for both AVPlayer and AVAudioPlayer
    private func startPlaybackObserver(for player: Any?) {
        removePlaybackObserver() // Ensure no duplicate observers

        if let avPlayer = player as? AVPlayer {
            playbackObserver = avPlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { [weak self] time in
                guard let self = self, let duration = avPlayer.currentItem?.duration.seconds else { return }
                let currentTime = time.seconds
                self.playbackProgress = currentTime / duration
            } as? AnyCancellable
        } else if let audioPlayer = player as? AVAudioPlayer {
            playbackObserver = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                self.playbackProgress = audioPlayer.currentTime / audioPlayer.duration
            } as? AnyCancellable
        }
    }

    // Stop existing playback
    private func stopPlayback() {
        audioPlayer?.stop()
        player?.pause()
        playbackObserver = nil
        isPlaying = false
    }

    func pause() {
        print("[MusicPlayerManager] pause")
        switch currentPlayerType {
        case .avPlayer:
            player?.pause()
        case .avAudioPlayer:
            audioPlayer?.pause()
        case .none:
            break
        }
        isPlaying = false
        updateNowPlayingInfo()
    }

    func togglePlayPause() {
        print("[MusicPlayerManager] togglePlayPause (index: \(currentIndex))")
        switch currentPlayerType {
        case .avPlayer:
            if player?.timeControlStatus == .playing {
                player?.pause()
            } else {
                player?.play()
            }
        case .avAudioPlayer:
            if audioPlayer?.isPlaying == true {
                audioPlayer?.pause()
            } else {
                audioPlayer?.play()
            }
        case .none:
            break
        }
        isPlaying.toggle()
        updateNowPlayingInfo()
        /*        if player?.timeControlStatus == .playing {
            pause()
        } else {
            play()
        }*/
    }

    // Update Now Playing info when toggling play/pause
    private func updateNowPlayingInfo() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0
    }

    func resume() {
        print("[MusicPlayerManager] resume")
        switch currentPlayerType {
        case .avPlayer:
            player?.play()
        case .avAudioPlayer:
            audioPlayer?.play()
        case .none:
            break
        }
        isPlaying = true
    }

    func next() {
        print("[MusicPlayerManager] next (index: \(currentIndex))")
        guard currentIndex + 1 < currentQueue.count else { return }
        currentIndex+=1
        playSong(at: currentIndex)
        print("[MusicPlayerManager] next (new index: \(currentIndex))")
        //updateNowPlayingPlaybackState()
    }

    func previous() {
        print("[MusicPlayerManager] previous")
        guard currentIndex - 1 >= 0 else { return }
        currentIndex-=1
        playSong(at: currentIndex)
        //updateNowPlayingPlaybackState()
    }

    // auto play next song in queue
    private func observeEndOfPlayback() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidReachEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil // Observe for any player item reaching the end
        )
    }

    // When a new song is played, the previous playback observer should be removed to avoid redundant updates.
    private func removePlaybackObserver() {
        if let observer = playbackObserver {
            player?.removeTimeObserver(observer)
            playbackObserver = nil
        }
        stopNowPlayingInfoTimer()
    }

    @objc private func playerItemDidReachEnd() {
        print("[MusicPlayerManager] playerItemDidReachEnd")
        stopNowPlayingInfoTimer()
        next()
    }

    private func setupNowPlayingInfo(for song: PlaySong) {
        //guard let playerItem = player?.currentItem, currentQueue.count > currentIndex else { return }
        //let song = currentQueue[currentIndex]
        var uiimage = UIImage(named:"icon-mt")

        var nowPlayingInfo: [String: Any] = [
            MPMediaItemPropertyTitle: song.title,
            MPMediaItemPropertyArtist: song.artist,
            MPMediaItemPropertyArtwork: MPMediaItemArtwork(boundsSize: CGSize(width: 300, height: 300), requestHandler: { _ in
                UIImage(named:"icon-mt")!
            }),
            //MPNowPlayingInfoPropertyElapsedPlaybackTime: playerItem.currentTime().seconds,
            //MPMediaItemPropertyPlaybackDuration: player?.currentTime().seconds,
            MPMediaItemPropertyPlaybackDuration: activePlayerDuration(),
            MPNowPlayingInfoPropertyPlaybackRate: isPlaying ? 1.0 : 0.0
        ]
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo

        // Asynchronously load cover image from URL and update Now Playing info
        if let coverImageURL = URL(string: song.coverImage) {
            downloadCoverImage(from: coverImageURL) { [weak self] image in
                guard let artworkImage = image else { return }

                // Update Now Playing info with the downloaded artwork
                nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: artworkImage.size) { _ in
                    artworkImage
                }
                self?.mediaPlayingInfo = nowPlayingInfo

                // Apply the updated Now Playing info
                MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            }
        }

        mediaPlayingInfo = nowPlayingInfo
        startNowPlayingInfoTimer()
    }

    // Determine the active player duration based on which player is currently in use
    private func activePlayerDuration() -> TimeInterval {
        if let avAudioPlayer = audioPlayer, avAudioPlayer.isPlaying {
            return avAudioPlayer.duration
        } else if let avPlayerItem = player?.currentItem {
            return avPlayerItem.duration.seconds
        }
        return 0
    }

    private func updateNowPlayingPlaybackInfo(nowPlayingInfo: [String: Any]) {
        var newInfo = nowPlayingInfo
        if let avAudioPlayer = audioPlayer, avAudioPlayer.isPlaying {
            newInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = avAudioPlayer.currentTime
            newInfo[MPNowPlayingInfoPropertyPlaybackRate] = avAudioPlayer.isPlaying ? 1.0 : 0.0
        } else if let avPlayer = player, avPlayer.rate > 0 {
            newInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = avPlayer.currentTime().seconds
            newInfo[MPNowPlayingInfoPropertyPlaybackRate] = avPlayer.rate
        } else {
            // If neither player is playing, set playback rate to 0
            newInfo[MPNowPlayingInfoPropertyPlaybackRate] = 0.0
        }

        MPNowPlayingInfoCenter.default().nowPlayingInfo = newInfo
    }

    private func startNowPlayingInfoTimer() {
        nowPlayingInfoTimer?.invalidate() // Invalidate any existing timer
        nowPlayingInfoTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateNowPlayingPlaybackInfo(nowPlayingInfo: self?.mediaPlayingInfo ?? [:])
        }
    }

    private func stopNowPlayingInfoTimer() {
        nowPlayingInfoTimer?.invalidate()
        nowPlayingInfoTimer = nil
    }

    // Asynchronously download cover image
    private func downloadCoverImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                print("[MusicPlayerManager] Failed to download cover image: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            completion(image)
        }.resume()
    }

    //  MARK: Lock screen playback controls
    func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.togglePlayPause()
            return .success
        }

        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.pause()
            return .success
        }

        commandCenter.togglePlayPauseCommand.addTarget { [weak self] _ in
            self?.togglePlayPause()
            return .success
        }

        commandCenter.nextTrackCommand.addTarget { [weak self] _ in
            self?.next()
            return .success
        }

        commandCenter.previousTrackCommand.addTarget { [weak self] _ in
            self?.previous()
            return .success
        }
    }

    // MARK: Offline caching for files
    // Generate local file path for song
    private func localFilePath(for song: PlaySong, fileExtension: String? = nil) -> URL? {
        let possibleExtensions = ["mp3", "wav", "m4a"]
        let baseFileName = "\(song.title)_\(song.artist)"
        // Document directory path
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to access document directory")
            return nil
        }

        for ext in possibleExtensions {
            let fileURL = documentDirectory.appendingPathComponent("\(baseFileName).\(ext)")
            if FileManager.default.fileExists(atPath: fileURL.path) {
                print("Found file with extension \(ext): \(fileURL.path)")
                return fileURL
            }
        }

        // No file found, create path
        if let fileExtension = fileExtension {
           let newFileURL = documentDirectory.appendingPathComponent("\(baseFileName).\(fileExtension)")
            print("File not found. Creating new path with provided extension: \(newFileURL.path)")
            return newFileURL
        }
        print("No file found and no valid file extension provided to create new file path.")
        return nil
    }

    // Download song for offline use
    func downloadSong(_ song: PlaySong) {
        DispatchQueue.global(qos: .background).async {
           // guard let self = self else { return }

        guard let remoteURL = URL(string: song.songUrl) else { return }

        // Skip download if file already exists
            if let localURL = self.localFilePath(for: song), FileManager.default.fileExists(atPath: localURL.path) {
            print("[MusicPlayerManager] File already exists at path: \(localURL.path)")
            return
        }

        print("[MusicPlayerManager] Downloading song \(song.title) with path: \(remoteURL)")

        // Download song from remote URL
        URLSession.shared.downloadTask(with: remoteURL) { (tempURL, response, error) in
            guard let tempURL = tempURL, error == nil,
                  let mimeType = response?.mimeType else {
                print("[MusicPlayerManager] Failed to download song: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            let fileExtension: String
            switch mimeType {
            case "audio/mpeg":
                fileExtension = "mp3"
            case "audio/wav":
                fileExtension = "wav"
            case "audio/wave":
                fileExtension = "wav"
            // Add cases for other formats if needed
            default:
                fileExtension = "none"  // Default to mp3 if unknown
            }
            print("[MusicPlayerManager] fileExtension: \(mimeType)")

            do {
                if let fileURL = self.localFilePath(for: song, fileExtension: fileExtension) {
                    try FileManager.default.moveItem(at: tempURL, to: fileURL)
                    print("[MusicPlayerManager] Downloaded song saved to: \(fileURL.path)")
                }
            } catch {
                print("[MusicPlayerManager] Failed to save song: \(error.localizedDescription)")
            }
        }.resume()

        }
    }

    private func removeFile(at url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
            print("Removed corrupted or unplayable file: \(url.lastPathComponent)")
        } catch {
            print("Failed to remove file at \(url): \(error)")
        }
    }
}
