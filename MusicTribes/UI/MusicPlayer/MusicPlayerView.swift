//
//  MusicPlayerView.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 6/6/24.
//

import SwiftUI

struct MusicPlayerView: View {
    var body: some View {
        HStack {
            Button(action: {
                print("play!")
            }) {
                Image(systemName: "play.circle")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color.customOrange)
            }
            Spacer()
            Button(action: {
                print("list!")
            }) {
                Image(systemName: "text.line.first.and.arrowtriangle.forward")
                    .resizable()
                    .frame(width: 35, height: 30)
                    .foregroundColor(Color.customOrange)
            }
        }.frame(minHeight: 40.0, alignment: .leading)
            .padding()
    }
}

#Preview {
    MusicPlayerView()
}


