//
//  ItemMenubar.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 19/6/24.
//

import SwiftUI

struct ItemMenubar: View {
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                print("play!")
            }) {
                Image(systemName: "play")
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.customOrange)
                    .symbolEffect(.breathe.plain.byLayer)
            }
            Spacer()
            Button(action: {
                print("add")
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.customOrange)
                    .symbolEffect(.breathe.plain.byLayer)
            }
            Spacer()
            Button(action: {
                print("share")
            }) {
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.customOrange)
                    .symbolEffect(.breathe.plain.byLayer)
            }
            Spacer()
            Button(action: {
                print("buy")
            }) {
                Image(systemName: "cart")
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.customOrange)
                    .symbolEffect(.breathe.plain.byLayer)
            }
            Spacer()
        }.opacity(0.7)
    }
}

#Preview {
    ItemMenubar()
}
