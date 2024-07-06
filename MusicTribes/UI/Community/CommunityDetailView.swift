//
//  CommunityDetailView.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 18/6/24.
//

import SwiftUI
//import SDWebImage
import SDWebImageSwiftUI

struct CommunityDetailView: View {    
    let collectedItem: CollectedItem = CollectedItem(
        image: "https://content.spinamp.xyz/image/upload/ipfs_image/QmXXNsLrQncxSpmA4NUhDtQ2U8GQbzKgxvn85zvW39pK1e",
        title: "Love Me",
        description: "Hi! I'm pleased to present this track here! It was made a little over a year ago, but only released now. This track is very interesting for me because of the experiments that were put into it. I wanted to make a track with a little vocal sample. But I don't have a microphone and I don't have a good singing voice. To realize this idea I involved my wife with an iPhone and an open messenger telegram. After a few minutes of experimentation, I got the result you'll hear in this track :) That was awesome, hope you enjoy listening to it!",
        sourceUrl: ""
    )
    
    @State private var rotationAngle: Angle = .degrees(0)
    private let rotationSpeed: Double = 30 // degrees per second


    
    var body: some View {
        VStack {
            WebImage(url: URL(string: collectedItem.image)) { image in
                image.resizable() // Control layout like SwiftUI.AsyncImage, you must use this modifier or the view will use the image bitmap size
                    .scaledToFit()
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(10.0)
            } placeholder: {
                Rectangle().foregroundColor(.black)
                    .cornerRadius(10.0)
            }
            .onSuccess { image, data, cacheType in
                // Success
                // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
            }
            .indicator(.activity) // Activity Indicator
            .transition(.fade(duration: 0.5)) // Fade Transition with duration
            .clipped()
            .frame(width: 130, height: 130, alignment: .top)
            .rotationEffect(rotationAngle)
            .onAppear(perform: startRotating)
            Spacer()
                .frame(height: 30)
            Text("George Hooks")
                .font(.largeTitle)
                .fontWeight(.black)
                .scaledToFit()
                .foregroundColor(.white)
            Text(collectedItem.title)
                .font(.title)
                .fontWeight(.black)
                .scaledToFit()
                .foregroundColor(.white)
            Text(collectedItem.description!)
                .fontWeight(.regular)
                .foregroundColor(.white)
                .padding(.all, 20.0)
                .lineLimit(nil)
                .transition(TextTransition())
            Spacer()
                .frame(height: 40.0)
            ItemMenubar()
                .opacity(0.7)
                .frame(height: 40.0)
            Spacer()
        }
    }
    
    private func startRotating() {
            let timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { _ in
                withAnimation(.linear(duration: 1.0 / 60.0)) {
                    rotationAngle += .degrees(rotationSpeed / 60.0)
                }
            }
            RunLoop.current.add(timer, forMode: .common)
        }
}

#Preview {
    CommunityDetailView()
}
