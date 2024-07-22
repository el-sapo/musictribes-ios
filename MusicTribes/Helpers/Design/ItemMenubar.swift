//
//  ItemMenubar.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 19/6/24.
//

import SwiftUI

struct ItemMenubar: View {
    @State var baseColor: Color = .customOrange
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                print("play!")
            }) {
                Image(systemName: "play")
                    .imageScale(.large)
                    .foregroundStyle(baseColor)
                    .symbolEffect(.breathe.plain.byLayer)
            }
            Spacer()
            Button(action: {
                print("add")
            }) {
                Image(systemName: "plus")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .symbolEffect(.breathe.plain.byLayer)
            }
            Spacer()
            Button(action: {
                print("share")
            }) {
                Image(systemName: "square.and.arrow.up")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .symbolEffect(.breathe.plain.byLayer)
            }
            Spacer()
            Button(action: {
                print("buy")
            }) {
                Image(systemName: "sparkles")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .symbolEffect(.breathe.plain.byLayer)
            }
            Spacer()
        }.opacity(0.7)
    }
}

#Preview {
    ItemMenubar()
}
