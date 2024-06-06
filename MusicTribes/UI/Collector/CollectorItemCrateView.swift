//
//  CollectorCrateView.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 17/5/24.
//

import SwiftUI

struct CollectorItemCrateView: View {
    let collectorCrate: CollectedArtist
    let collectionCrateItems: [CollectedItem]
    let crateWidth: CGFloat = 150.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                CarouselView(
                    allImages: .constant(collectionCrateItems.map { $0.image }),
                    maxWidth: .constant(geometry.size.width)
                )
                /*Image("mt-bw")
                 .resizable()
                 .imageScale(.large)
                 .foregroundStyle(.tint)
                 .aspectRatio(1, contentMode: .fit)
                 .cornerRadius(10.0)
                 .clipped()*/
                Text(collectorCrate.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .scaledToFit()
                    .minimumScaleFactor(0.5)
                    .frame(minHeight: 20.0)
                Text("collected " + collectorCrate.collectedNumber)
                    .fontWeight(.regular)
                    .scaledToFit()
                    .minimumScaleFactor(0.5)
                    .frame(minHeight: 20.0)
            }
        }
    }
}

#Preview {
    CollectorItemCrateView( 
        collectorCrate: 
            CollectedArtist(
                contract: "",
                name: "Sound of Fractures",
                collectedNumber: "104"
            ), 
        collectionCrateItems: MockData.collectedItems
    )
}

/**
 Ideas:
    on tap of image cycle between the crate items
 **/


struct CarouselView: View {
    @Binding var allImages: [String]
    @Binding var maxWidth: CGFloat

    private let maxItems = 3
    @State private var currentIndex: Int = 0
    @State private var offsetBetweenImages: CGFloat = 10.0
    @State private var sizeDifferencePercentage: CGFloat = 0.0

    // Computed property to get the first 3 images starting from currentIndex
    private var images: [String] {
        var result: [String] = []
        for i in 0..<maxItems {
            let index = (currentIndex + i)
            if allImages.count > index {
                result.append(allImages[index])
            }
        }
        return result
    }
    private var baseWidth: CGFloat {
        return maxWidth - offsetBetweenImages * CGFloat(maxItems)
    }
    
    var body: some View {
        VStack {
            ZStack {
                ForEach(0..<images.count, id: \.self) { index in
                    Image(self.images[index])
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(1, contentMode: .fit)
                        .cornerRadius(5.0)
                        .zIndex(self.zIndex(for: index))
                        .frame(
                            width: self.frameSize(for: index),
                            height: self.frameSize(for: index)
                        )
                        .position(
                            x: offsetX(for: index),
                            y: offsetY(for: index)
                        )
                        .clipped()
                        .onTapGesture {
                            withAnimation(.spring()) {
                                self.handleTap()
                            }
                        }
                }
            }.frame(width: maxWidth, height: maxWidth, alignment: .bottomLeading)
        }.frame(width: maxWidth, height: maxWidth, alignment: .bottomLeading)
    }
    
    // Calculate frame size based on index
        private func frameSize(for index: Int) -> CGFloat {
            print(baseWidth)
            return baseWidth
            let baseSize = baseWidth
            let percentageReduction = CGFloat(index) * sizeDifferencePercentage / 100
            return baseSize * (1 - percentageReduction)
        }
        
        // Calculate Y offset based on index
        private func offsetY(for index: Int) -> CGFloat {
            var offset = maxWidth / 2
            switch index {
            case 0:
                offset+=offsetBetweenImages
            case 2:
                offset-=offsetBetweenImages
            default:
                break
            }
            print("index \(index) offset \(offset)")
            return offset
        }
    
        // Calculate X offset based on index
        private func offsetX(for index: Int) -> CGFloat {
            var offset = maxWidth / 2
            switch index {
            case 0:
                offset-=offsetBetweenImages
            case 2:
                offset+=offsetBetweenImages
            default:
                break
            }
            print("index \(index) offset \(offset)")
            return offset
        }

        // Calculate zIndex based on index
        private func zIndex(for index: Int) -> Double {
            return Double(-index)
        }
        
        // Handle the tap gesture to move images
        private func handleTap() {
            currentIndex = (currentIndex + 1) % allImages.count
/*
            currentIndex = (currentIndex + 1)
            if currentIndex > allImages.count {
                currentIndex = 0
            }*/
        }
}
