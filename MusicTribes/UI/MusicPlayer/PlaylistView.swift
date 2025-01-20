//
//  PlaylistView.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 29/11/24.
//

import SwiftUI
import Combine

private struct Constants {
    static let buttonSize = 25.0
}

struct PlaylistView: View {
    @ObservedObject var viewModel: PlaylistViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            HStack {
                Text("Now Playing")
                    .myFont(style: .light, size: 18.0)
                    .foregroundColor(Color.customOrange)
                Spacer()
                Image("spotify-logo")
                    .resizable()
                    .tint(Color.customOrange)
                    .foregroundColor(Color.customOrange)
                    .frame(width: Constants.buttonSize, height: Constants.buttonSize)
                    .padding(.horizontal, 20.0)
                Button(action: {
                    withAnimation {
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Image(systemName: "multiply.square")
                        .resizable()
                        .frame(width: Constants.buttonSize, height: Constants.buttonSize)
                        .foregroundColor(Color.customOrange)
                        .ifiOS18OrLater { view in
                            view.symbolEffect(.breathe.plain.byLayer)
                        }
                }
            }
//            .padding(.bottom, 210.0)
            .padding()
            List {
                ForEach(viewModel.playbackQueue.indices, id: \.self) { index in
                    PlaylistRow(
                        viewModel: PlaylistRowViewModel(
                            song: $viewModel.playbackQueue[index],
                            isPlaying: index == viewModel.currentIndex
                        )
                    )
                    .background(Color.clear) // Ensures transparent row
                    .listRowInsets(EdgeInsets()) // Removes padding from the row
                    .onTapGesture {
                        viewModel.playSong(at: index)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .listRowSeparatorTint(.customGreen)
            .background(Color.black)
            .padding(.zero)
        }
        // TODO: set custom color or it will break with light/dark schemes
        //.background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct PlaylistRow: View {
    @ObservedObject var viewModel: PlaylistRowViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.song.title)
                    .myFont(style: .regular, size: 18.0)
                    .foregroundColor(viewModel.colorForPlaybackState())
                Text(viewModel.song.artist)
                    .myFont(style: .light, size: 18.0)
                    .padding(.leading, 10.0)
                    .foregroundColor(viewModel.colorForPlaybackState())
            }
            Spacer()
            if viewModel.isPlaying {
                Image(systemName: "speaker.wave.2.fill")
                    .foregroundColor(viewModel.colorForPlaybackState())
            }
        }
        .padding(.all, 8)
        .background(viewModel.backColor)
    }
}

class PlaylistRowViewModel: ObservableObject {
    @Binding var song: PlaySong
    @Published var isPlaying: Bool
    var backColor: Color = .black
    var fontColor: Color = .customGreen

    init(song: Binding<PlaySong>, isPlaying:  Bool) {
        self._song = song
        self.isPlaying = isPlaying
    }

    func colorForPlaybackState() -> Color {
        if isPlaying {
            return .customOrange
        } else {
            return .customGreen
        }
    }

    func playSong() {
        MusicPlayerManager.shared.play(song: song)
    }
}

#Preview {
    PlaylistView(viewModel: PlaylistViewModel())
}

class PlaylistViewModel: ObservableObject {
    @Published var playbackQueue: [PlaySong] = []
    @Published var currentSong: PlaySong?
    @Published var currentIndex: Int = 0
    private var cancellables = Set<AnyCancellable>()

    init() {
        setupBindings()
    }

    private func setupBindings() {
        MusicPlayerManager.shared.$currentQueue
            .receive(on: DispatchQueue.main)
            .sink { [weak self] queue in
                self?.playbackQueue = queue
            }
            .store(in: &cancellables)

        MusicPlayerManager.shared.$currentSong
            .receive(on: DispatchQueue.main)
            .sink { [weak self] song in
                self?.currentSong = song
            }
            .store(in: &cancellables)

        MusicPlayerManager.shared.$currentIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                self?.currentIndex = index
            }
            .store(in: &cancellables)
    }

    func playSong(_ song: PlaySong) {
        MusicPlayerManager.shared.play(song: song)
    }

    func playSong(at index: Int) {
        let song = playbackQueue[index]
        currentIndex = index
        MusicPlayerManager.shared.play(song: song)
    }

    func removeSong(_ song: PlaySong) {
        MusicPlayerManager.shared.removeFromQueue(song)
    }
}
