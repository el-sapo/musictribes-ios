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
    @State private var showPlaylist = false

    // TODO: just show play button and use gestures!! right, left, up (playing + list)
    // TODO: show animation around play button or equalizers
    var body: some View {
        HStack {
            VStack {
                if viewModel.showSongDetails {
                    Text("\(viewModel.songTitle) (by \(viewModel.songArtist))")
                        .myFont(style: .bold, size: 18.0)
                        .scaledToFit()
                        .foregroundColor(.customOrange)
                        .myTribesGlow(color: .white)
                        .frame(height: 20.0)
                        .padding(.top, 5.0)
                }
                if viewModel.musicPlayer.playbackProgress > 0 {
                    ProgressView(value: viewModel.musicPlayer.playbackProgress)
                        .frame(height: 5.0)
                }
                HStack {
                    Button(action: { viewModel.musicPlayer.previous() }) {
                        Image(systemName: "chevron.backward.square.fill")
                            .resizable()
                            .frame(width: Constants.buttonSize, height: Constants.buttonSize)
                            .foregroundColor(Color.customOrange)
                            .ifiOS18OrLater { view in
                                view.symbolEffect(.breathe.plain.byLayer)
                            }
                    }
                    .padding()
                    Button(action: {
                        if viewModel.musicPlayer.isPlaying {
                            viewModel.musicPlayer.pause()
                        } else {
                            viewModel.musicPlayer.resume()
                        }
                    }) {
                            Image(systemName: viewModel.musicPlayer.isPlaying ? "pause.fill" : "play.square.fill")
                                .resizable()
                                .frame(width: Constants.buttonSize, height: Constants.buttonSize)
                                .foregroundColor(Color.customOrange)
                                .ifiOS18OrLater { view in
                                    view.symbolEffect(.breathe.plain.byLayer)
                                }
                    }
                    .padding()
                    Button(action: { viewModel.musicPlayer.next() }) {
                        Image(systemName: "chevron.forward.square.fill")
                            .resizable()
                            .frame(width: Constants.buttonSize, height: Constants.buttonSize)
                            .foregroundColor(Color.customOrange)
                            .ifiOS18OrLater { view in
                                view.symbolEffect(.breathe.plain.byLayer)
                            }
                    }
                    .padding()
                    Button(action: {
                        showPlaylist.toggle()
                    }) {
//                        Image(systemName: "music.note.list")
                        Image("playlist-icon")
                            .resizable()
                            .tint(Color.customOrange)
                            .foregroundColor(Color.customOrange)
                            .frame(width: Constants.buttonSize, height: Constants.buttonSize)
                            .ifiOS18OrLater { view in
                                view.symbolEffect(.breathe.plain.byLayer)
                            }
                    }
                    .padding()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black)
                .shadow(radius: 10)
        )
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $showPlaylist) {
            PlaylistView(viewModel: PlaylistViewModel())
                .transition(.move(edge: .bottom))
                .zIndex(1)
                .presentationDetents([.medium, .large])
        }
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
    @Published var songTitle: String = ""
    @Published var songArtist: String = ""
    private var cancellables = Set<AnyCancellable>()

    init() {
        musicPlayer.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send() // Propagate changes to the view
            }
            .store(in: &cancellables)
        setupObservers()
    }


    func setupObservers() {
        musicPlayer.$currentSong
            .sink { _ in
        } receiveValue: { song in
            self.songTitle = song.title
            self.songArtist = song.artist
        }.store(in: &cancellables)
    }

    var showSongDetails: Bool {
        return !songTitle.isEmpty || !songArtist.isEmpty
    }
}
