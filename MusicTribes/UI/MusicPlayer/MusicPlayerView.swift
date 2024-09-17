//
//  MusicPlayerView.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 6/6/24.
//

import SwiftUI
import Combine

private struct Constants {
    static let buttonSize = 25.0
}

struct MusicPlayerView: View {
    @State var count: Int = 0
    @StateObject var viewModel = MusicPlayerViewModel()


    // TODO: just show play button and use gestures!! right, left, up (playing + list)
    // TODO: show animation around play button or equalizers
    var body: some View {
        HStack {
            VStack {
                if viewModel.showSongDetails {
                    Text("\(viewModel.playingTitle) (by \(viewModel.playingArtist))")
                        .myFont(style: .bold, size: 12.0)
                        .scaledToFit()
                        .foregroundColor(.customOrange)
                        .myTribesGlow(color: .white)
                        .frame(height: 20.0)
                        .padding(.top, 10.0)
                }
                HStack {
                    Button(action: { viewModel.musicPlayer.previous() }) {
                        Image(systemName: "backward.circle")
                            .resizable()
                            .frame(width: Constants.buttonSize, height: Constants.buttonSize)
                            .foregroundColor(Color.customOrange)
                            .symbolEffect(.breathe.plain.byLayer)
                    }
                    .padding(.all, 10.0)
                    Button(action: {
                        if viewModel.musicPlayer.isPlaying {
                            viewModel.musicPlayer.pause()
                        } else {
                            viewModel.musicPlayer.resume()
                        }
                    }) {
                        Image(systemName: viewModel.musicPlayer.isPlaying ? "pause.circle" : "play.circle")
                            .resizable()
                            .frame(width: Constants.buttonSize, height: Constants.buttonSize)
                            .foregroundColor(Color.customOrange)
                            .symbolEffect(.breathe.plain.byLayer)
                    }
                    .padding(.all, 10.0)
                    Button(action: { viewModel.musicPlayer.next() }) {
                        Image(systemName: "forward.circle")
                            .resizable()
                            .frame(width: Constants.buttonSize, height: Constants.buttonSize)
                            .foregroundColor(Color.customOrange)
                            .symbolEffect(.breathe.plain.byLayer)
                    }
                    .padding(.all, 10.0)
                    Button(action: {
                        print("list!")
                    }) {
                        Image(systemName: "eject.circle")
                            .resizable()
                            .frame(width: Constants.buttonSize, height: Constants.buttonSize)
                            .foregroundColor(Color.customOrange)
                            .symbolEffect(.breathe.plain.byLayer)
                    }
                    .padding(.all, 10.0)
                }
                ProgressView(value: viewModel.musicPlayer.playbackProgress)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.customCream) // Background color for the rounded rectangle
                    .shadow(radius: 10) // Optional: Add a shadow for better visual effect
            )

        }
        .padding()
        .background(Color.clear)
    }
}

#Preview {
    MusicPlayerView()
}


enum MusicPlayerState {
    case none
    case playing
    case pause
}

class MusicPlayerViewModel: ObservableObject {
    @Published var musicPlayer = MusicPlayerManager.shared

    var playingTitle: String {
        return musicPlayer.currentSong?.title ?? ""
    }
    var playingArtist: String {
        return musicPlayer.currentSong?.artist ?? ""
    }

    var showSongDetails: Bool {
        return musicPlayer.currentSong != nil
    }

    init() {
        musicPlayer.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send() // Propagate changes to the view
            }
            .store(in: &cancellables)
    }

    private var cancellables = Set<AnyCancellable>()
}
