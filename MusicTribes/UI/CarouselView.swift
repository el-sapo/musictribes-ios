//
//  CarouselView.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 30/10/24.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct CarouselView: View {
    @EnvironmentObject var vmCrate: CrateViewModel
    @ObservedObject var vm: CarouselViewModel

    @Binding var maxWidth: CGFloat
    let offsetBetweenImages: CGFloat
    let maxItems: Int
    
    @State var currentIndex: Int
    @State private var sizeDifferencePercentage: CGFloat = 0.0

    // animations
    @State var isVisible: Bool = false
    @State var counter: Int = 0
    @State var origin: CGPoint = .zero
    
    // images to show in the carousell
    var imageCount: Int {
        return vm.allImages.count < maxItems ? vm.allImages.count : maxItems
    }

    private var images: [String] {
        var result: [String] = []
        for i in 0..<imageCount {
            let index = currentIndex + i
            if vm.allImages.count > index {
                result.append(vm.allImages[index])
            } else {
                let newIndex = index - vm.allImages.count
                result.append(vm.allImages[newIndex])
            }
        }
        return result
    }

    private var baseWidth: CGFloat {
        return maxWidth - offset * CGFloat(maxItems)
    }
    
    var offset: CGFloat {
        return maxWidth * 0.2 / CGFloat(maxItems)
    }
    
    var body: some View {
        VStack {
            ZStack {
                ForEach(0..<images.count, id: \.self) { index in
                    WebImage(url: URL(string: self.images[index]), options: [.decodeFirstFrameOnly, .scaleDownLargeImages]) { image in
                            image.resizable() // Control layout like SwiftUI.AsyncImage, you must use this modifier or the view will use the image bitmap size
                            .scaledToFit()
                            .aspectRatio(1, contentMode: .fit)
                            .cornerRadius(5.0)
                    } placeholder: {
                            Rectangle().foregroundColor(.gray)
                    }
                        // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
                    .onSuccess { image, data, cacheType in
                            // Success
                            // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                        }
                        .indicator(.activity) // Activity Indicator
                        .transition(.fade(duration: 0.1)) // Fade Transition with duration
                        .zIndex(self.zIndex(for: index))
                        .frame(
                            width: baseWidth,
                            height: baseWidth
                        )
                        .position(
                            x: offsetX(for: index),
                            y: offsetY(for: index)
                        )
                        .onTapGesture {
                            withAnimation(.spring()) {
                                self.handleTap()
                            }
                        }
                        .padding(.all, 0.0)
                        .onPressingChanged { point in
                            if let point {
                                origin = point
                                counter += 1
                            }
                        }
                        .if(index == 0) { view in
                            view.modifier(RippleEffect(at: origin, trigger: counter))
                        }
                }
            }.frame(width: baseWidth, height: baseWidth, alignment: .center)
        }.frame(width: baseWidth, height: baseWidth, alignment: .center)
            .onAppear {
                withAnimation {
                    isVisible = true
                }
        }
    }
    
    private func frameSize(for index: Int) -> CGFloat {
            return baseWidth
    }

    // Calculate Y offset based on index
    private func offsetY(for index: Int) -> CGFloat {
        let centerIndex = imageCount / 2
        let newOffset = CGFloat(centerIndex - index) * offset
        
        // Adjust to center the images vertically
        return newOffset + baseWidth / 2
    }

    // Calculate X offset based on index
    private func offsetX(for index: Int) -> CGFloat {
        let centerIndex = imageCount / 2
        // Calculate offset for each index
        let newOffset = CGFloat(index - centerIndex) * offset
           
        // Adjust base width to center the images
        return newOffset + baseWidth / 2
    }

    // Calculate zIndex based on index
    private func zIndex(for index: Int) -> Double {
        return Double(-index)
    }
    
    // Handle the tap gesture to move images
    private func handleTap() {
        currentIndex = (currentIndex + 1) % vm.allImages.count
        vmCrate.updateCurrentItemIndex(index: currentIndex)
    }
}

struct CarouselScrollView: View {
    @Binding var allImages: [String]
    @Binding var baseWidth: CGFloat
    
    var baseHeight: CGFloat {
        return baseWidth * 1.20
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ForEach(0..<allImages.count, id: \.self) { index in
                    WebImage(url: URL(string: self.allImages[index]), options: [.decodeFirstFrameOnly, .scaleDownLargeImages]) { image in
                        image.resizable() // Control layout like SwiftUI.AsyncImage, you must use this modifier or the view will use the image bitmap size
                            .scaledToFit()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: baseWidth, height: baseHeight)
                            .cornerRadius(5.0)
                    } placeholder: {
                        Rectangle().foregroundColor(.gray)
                            .frame(width: baseWidth, height: baseHeight)
                            .cornerRadius(5.0)
                    }.visualEffect { content, proxy in
                        let frame = proxy.frame(in: .scrollView(axis: .vertical))
                        let parentBounds = proxy
                            .bounds(of: .scrollView(axis: .vertical)) ??
                            .infinite

                        // The distance this view extends past the bottom edge
                        // of the scroll view.
                        let distance = min(0, frame.minY)

                        return content
                            .hueRotation(.degrees(frame.origin.y / 10))
                            .scaleEffect(1 + distance / 700)
                            .offset(y: -distance / 1.25)
                            .brightness(-distance / 400)
                            .blur(radius: -distance / 50)
                    }
                }
            }
        }
        .scrollTargetBehavior(.paging)
    }
}

/*
#Preview("Position-based Hue & Scale") {
    ScrollView(.vertical) {
        VStack {
            ForEach(0 ..< 20) { _ in
                RoundedRectangle(cornerRadius: 24)
                    .fill(.purple)
                    .frame(height: UIScreen.main.bounds.width)
                    .visualEffect { content, proxy in
                        let frame = proxy.frame(in: .scrollView(axis: .vertical))
                        let parentBounds = proxy
                            .bounds(of: .scrollView(axis: .vertical)) ??
                            .infinite

                        // The distance this view extends past the bottom edge
                        // of the scroll view.
                        let distance = min(0, frame.minY)

                        return content
                            .hueRotation(.degrees(frame.origin.y / 10))
                            .scaleEffect(1 + distance / 700)
                            .offset(y: -distance / 1.25)
                            .brightness(-distance / 400)
                            .blur(radius: -distance / 50)
                    }
            }
        }
        .padding()
    }
}*/

class CarouselViewModel: ObservableObject {
    var allImages: [String] = []
    var allTitles: [String] = []

    init(currentItemIndex: Int = 0, allImages: [String], allTitles: [String]) {
        self.allImages = allImages
        self.allTitles = allTitles
    }
}

