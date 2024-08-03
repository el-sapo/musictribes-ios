//
//  CollectorCrateView.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 17/5/24.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct CrateViewConfig {
    let showTextTop: Bool
    let showTextBottom: Bool
    let showCount: Bool
    let crateOffset: CGFloat
    let maxItems: Int
    
    init(showTextTop: Bool = false,
         showTextBottom: Bool = false,
         showCount: Bool = false,
         crateOffset: CGFloat = 5.0,
         maxItems: Int = 3) {
            self.showTextTop = showTextTop
            self.showTextBottom = showTextBottom
            self.showCount = showCount
            self.crateOffset = crateOffset
            self.maxItems = maxItems
        }
}

private struct UIConstants {
    static let frameBorder = 5.0
}

struct CrateView: View {
    @ObservedObject var vmCrate: CrateViewModel
    var body: some View {
        VStack {
            Text(vmCrate.title)
                .customAttribute(EmphasisAttribute())
                .myFont(style: .big, size: 16.0)
                .scaledToFit()
                .foregroundColor(.customCream)
                .transition(TextTransition())
                .myAnimatedGlow(color: .white)
                .frame(maxWidth: .infinity)
                .padding(.all, 3.0)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.customGreen) // Background color for the rounded rectangle
                        .shadow(radius: 10) // Optional: Add a shadow for better visual effect
                )
            VStack {
                CollectorItemCrateView(vmCrate: vmCrate)
                    .offset(CGSize(width: UIConstants.frameBorder, height: UIConstants.frameBorder))
                    .padding(.trailing, UIConstants.frameBorder)
                    .padding(.leading, UIConstants.frameBorder)
                if !vmCrate.subtitle.isEmpty {
                    Text(vmCrate.subtitle)
                        .customAttribute(EmphasisAttribute())
                        .myFont(style: .regular, size: 14.0)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .scaledToFit()
                        .foregroundColor(.customCream)
                        .transition(TextTransition())
                        .padding(.all, 3.0)
                } else {
                    Spacer()
                        .frame(height: 20)
                }
            }
            .padding(.all, 0.0)
            .cornerRadius(10.0)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black)
                    .cornerRadius(10.0)
                    .opacity(0.4)
                    .shadow(radius: 10)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.customGreen, lineWidth: 3)
            )
        }
    }
}

struct CommunityCrateView: View {
    @ObservedObject var vmCrate: CrateViewModel
    var body: some View {
        VStack {
            Text(vmCrate.title)
                .customAttribute(EmphasisAttribute())
                .myFont(style: .big, size: 16.0)
                .scaledToFit()
                .foregroundColor(.customCream)
                .transition(TextTransition())
                .myAnimatedGlow(color: .white)
                .frame(maxWidth: .infinity)
                .padding(.top, 5.0)
            VStack {
                if vmCrate.crateItems.count > 0 {
                    CollectorItemCrateView(
                        vmCrate: CrateViewModel(
                            crateItems: vmCrate.crateItems,
                            crateConfig: CrateViewConfig(
                                showTextTop: false,
                                showTextBottom: true,
                                showCount: false,
                                crateOffset: 20.0,
                                maxItems: min(vmCrate.crateItems.count, 5)
                            )

                        )
                    )
                    .offset(CGSize(width: UIConstants.frameBorder / 2, height: UIConstants.frameBorder / 2))
                    .padding(.trailing, UIConstants.frameBorder / 2)
                    .padding(.leading, UIConstants.frameBorder / 2)
                    //.clipped()
                }
                Text(vmCrate.subtitle)
                        .customAttribute(EmphasisAttribute())
                        .myFont(style: .regular, size: 14.0)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .scaledToFit()
                        .foregroundColor(.customCream)
                        .transition(TextTransition())
                        .padding(.all, 3.0)

            }
     //       .frame(width: UIScreen.main.bounds.width - UIConstants.frameBorder * 2)
            .padding(.all, 3.0)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.black) // Background color for the rounded rectangle
                    .opacity(0.8)
                    .shadow(radius: 10)
            )
            Spacer()
                .frame(height: UIConstants.frameBorder / 2)
        }
//        .frame(width: UIScreen.main.bounds.width - UIConstants.frameBorder) // Add padding to the entire ZStack
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.customOrange) // Background color for the rounded rectangle
                .shadow(radius: 10) // Optional: Add a shadow for better visual effect
                .opacity(0.7)
        ).overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.customOrange, lineWidth: 3)
        )
    }
}


#Preview {
    VStack {
        CommunityCrateView(vmCrate:
            CrateViewModel(
                crateItems:
                    [CrateItem(
                        artist: CollectedArtist(contract: "",
                                                name: "DANC3",
                                                collectedNumber: "1",
                                                collectedItems: []),
                        song: CollectedItem(image: "",
                                            title: "mixtape",
                                            description: "description", sourceUrl: "")),
                     CrateItem(
                        artist: CollectedArtist(contract: "",
                                                name: "Scenes",
                                                collectedNumber: "3",
                                                collectedItems: []),
                        song: CollectedItem(image: "",
                                            title: "Willow",
                                            description: "description",
                                            sourceUrl: "")
                        )]
            )
        )
        CrateView(vmCrate:
                    CrateViewModel(
                        crateItems:
                            [CrateItem(
                                artist: CollectedArtist(contract: "",
                                                        name: "DANC3",
                                                        collectedNumber: "1",
                                                        collectedItems: []),
                                song: CollectedItem(image: "album-1",
                                                    title: "mixtape",
                                                    description: "description", sourceUrl: "")),
                             CrateItem(
                                artist: CollectedArtist(contract: "",
                                                        name: "Scenes",
                                                        collectedNumber: "3",
                                                        collectedItems: []),
                                song: CollectedItem(image: "album-1",
                                                    title: "Willow",
                                                    description: "description",
                                                    sourceUrl: "")
                             )]
                    )
        )
    }
}


struct CollectorItemCrateView: View {
    @ObservedObject var vmCrate: CrateViewModel

    let crateWidth: CGFloat = 150.0
    var crateTitle: String {
        return "title"
//        var text = vmCrate.crateItems.artist.name
//        if vmCrate.crateConfig.showCount {
//            text = text + " \(vmCrate.artist.collectedNumber)"
//        }
//        return text
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                CarouselView(
                    vmCrate: vmCrate,
                    allImages: .constant(vmCrate.crateItems.map { $0.song.image }),
                    allTitles: .constant(vmCrate.crateItems.map { $0.song.title }),
                    maxWidth: .constant(geometry.size.width),
                    offsetBetweenImages: vmCrate.crateConfig.crateOffset,
                    maxItems: vmCrate.crateConfig.maxItems
                ).frame(
                    width: geometry.size.width,
                    height: geometry.size.width
                )
            }
        }
    }
}

//#Preview {
//    CollectorItemCrateView(
//        vmCrate: CrateViewModel(currentItemIndex: 0, crateItems: [])
//    )
//}

/**
 Ideas:
    on tap of image cycle between the crate items
 **/


struct CarouselView: View {
    @ObservedObject var vmCrate: CrateViewModel

    @Binding var allImages: [String]
    @Binding var allTitles: [String]
    @Binding var maxWidth: CGFloat
    let offsetBetweenImages: CGFloat
    let maxItems: Int
    
    @State private var currentIndex: Int = 0
    @State private var sizeDifferencePercentage: CGFloat = 0.0

    // animations
    @State var isVisible: Bool = false
    @State var counter: Int = 0
    @State var origin: CGPoint = .zero
    
    // images to show in the carousell
    var imageCount: Int {
        return allImages.count < maxItems ? allImages.count : maxItems
    }

    private var images: [String] {
        var result: [String] = []
        for i in 0..<imageCount {
            let index = currentIndex + i
            if allImages.count > index {
                result.append(allImages[index])
            } else {
                let newIndex = index - allImages.count
                result.append(allImages[newIndex])
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
                    WebImage(url: URL(string: self.images[index])) { image in
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
        .onReceive(vmCrate.$currentItemIndex) { newValue in
            self.currentIndex = newValue
        }
        .onChange(of: currentIndex) {
            vmCrate.currentItemIndex = currentIndex
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
        currentIndex = (currentIndex + 1) % allImages.count
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
                    WebImage(url: URL(string: self.allImages[index])) { image in
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

class CrateViewModel: ObservableObject {
    @Published var currentItemIndex: Int = 0
    let crateItems: [CrateItem]
    let crateConfig: CrateViewConfig
    @Published var currentTitle: String = "TITLE"
    @Published var currentSubTitle: String = "description"

    var title: String {
        return crateItems.first?.artist.name ?? ""
    }

    var subtitle: String {
        return crateItems[currentItemIndex].song.title ?? ""
    }

    init(currentItemIndex: Int = 0,
         crateItems: [CrateItem],
         crateConfig: CrateViewConfig = CrateViewConfig()) {
        self.currentItemIndex = currentItemIndex
        self.crateItems = crateItems
        self.crateConfig = crateConfig
    }
}
