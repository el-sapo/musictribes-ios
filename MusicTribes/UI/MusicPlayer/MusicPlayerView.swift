//
//  MusicPlayerView.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 6/6/24.
//

import SwiftUI

struct MusicPlayerView: View {
    @State var count: Int = 0

    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Button(action: {
                    print("play!")
                }) {
                    Image(systemName: "play.circle")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color.customOrange)
                        .symbolEffect(.breathe.plain.byLayer)
                }
                Spacer()
            }
            HStack {
                Spacer()
                Button(action: {
                    print("list!")
                }) {
                    Image(systemName: "eject")
                        .resizable()
                        .frame(width: 35, height: 30)
                        .foregroundColor(Color.customOrange)
                        .symbolEffect(.breathe.plain.byLayer)
                }
                .padding(.trailing, 20.0)
            }
        }
    }
}

#Preview {
    MusicPlayerView()
}


