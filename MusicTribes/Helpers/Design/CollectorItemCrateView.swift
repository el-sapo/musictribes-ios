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
    let color: Color

    init(showTextTop: Bool = false,
         showTextBottom: Bool = false,
         showCount: Bool = false,
         crateOffset: CGFloat = 5.0,
         maxItems: Int = 3,
         color: Color = .customGreen) {
            self.showTextTop = showTextTop
            self.showTextBottom = showTextBottom
            self.showCount = showCount
            self.crateOffset = crateOffset
            self.maxItems = maxItems
            self.color = color
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
                .myFont(style: .big, size: 16.0)
                .scaledToFit()
                .foregroundColor(.customCream)
                .transition(TextTransition())
                .frame(maxWidth: .infinity)
                .padding(.all, 3.0)
            VStack {
                CollectorItemCrateView()
                    .environmentObject(vmCrate)
                    .offset(CGSize(width: UIConstants.frameBorder, height: UIConstants.frameBorder))
                    .padding(.trailing, UIConstants.frameBorder)
                    .padding(.leading, UIConstants.frameBorder)
                if !vmCrate.currentSubTitle.isEmpty {
                    Text(vmCrate.currentSubTitle)
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
                    .opacity(0.6)
                    .shadow(radius: 10)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.customGreen, lineWidth: 3)
            )
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.customGreen) // Background color for the rounded rectangle
                .shadow(radius: 10) // Optional: Add a shadow for better visual effect
                .opacity(0.7)
        ).overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.customGreen, lineWidth: 3)
        )
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
                    CollectorItemCrateView()
                        .environmentObject(vmCrate)
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
    @EnvironmentObject var vmCrate: CrateViewModel

    let crateWidth: CGFloat = 150.0
    var crateTitle: String {
        return "..."
    }
    @State var counter: Int = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(alignment: .leading) {
                    CarouselView(
                        vm: CarouselViewModel(
                            allImages: vmCrate.crateItems.map { $0.song.image },
                            allTitles: vmCrate.crateItems.map { $0.song.title }),
                        maxWidth: .constant(geometry.size.width),
                        offsetBetweenImages: vmCrate.crateConfig.crateOffset,
                        maxItems: vmCrate.crateConfig.maxItems,
                        currentIndex: vmCrate.currentItemIndex
                    ).frame(
                        width: geometry.size.width,
                        height: geometry.size.width
                    )
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer().frame(width: 5.0)
                        Button(action: {
                            vmCrate.playCurrentItem()
                            counter += 1
                        }) {
                            Image(systemName: "play.square.fill")
                                .resizable()
                                .foregroundStyle(vmCrate.crateConfig.color)
                                .symbolEffect(.breathe.plain.byLayer)
                                .frame(width: 30.0, height: 30.0)
                                .shadow(color: Color.black, radius: 10.0, x: 25.0, y: 25.0)
                        }
                        .buttonStyle(MyButtonStyle())
                        Spacer().frame(width: 20.0)
                        Button(action: {
                            vmCrate.queueCurrentItem()
                            counter += 1
                        }) {
                            Image(systemName: "plus.square.fill")
                                .resizable()
                                .foregroundStyle(vmCrate.crateConfig.color)
                                .frame(width: 30.0, height: 30.0)
                                .symbolEffect(.breathe.plain.byLayer)
                        }.buttonStyle(MyButtonStyle())

                        Spacer()
                    }
                }.opacity(0.9)
            }
            .modifier(RippleEffect(at: CGPointMake(0.0, geometry.size.height), trigger: counter))
        }
    }
}

class CrateViewModel: ObservableObject {
    @Published var currentItemIndex: Int
    let crateItems: [CrateItem]
    let crateConfig: CrateViewConfig
    @Published var currentTitle: String = "TITLE"
    @Published var currentSubTitle: String = "description"

    var title: String {
        return crateItems.first?.artist.name ?? ""
    }

    var subtitle: String {
        if crateItems[currentItemIndex].song.title == "Willow's Heartbeat (Scene 1)" {
            return "SCENES"
        }
        return crateItems[currentItemIndex].song.title
    }

    init(currentItemIndex: Int = 0,
         crateItems: [CrateItem],
         crateConfig: CrateViewConfig = CrateViewConfig()) {
        self.currentItemIndex = currentItemIndex
        self.currentItemIndex = currentItemIndex
        self.crateItems = crateItems
        self.crateConfig = crateConfig
        if !crateItems.isEmpty {
            self.currentSubTitle = crateItems[currentItemIndex].song.title
        }
    }

    func playCurrentItem() {
        let playSong = crateItems[currentItemIndex].songToPlay()
        MusicPlayerManager.shared.addToQueue(playSong, play: true)
    }

    func queueCurrentItem() {
        let playSong = crateItems[currentItemIndex].songToPlay()
        MusicPlayerManager.shared.addToQueue(playSong)
    }

    func updateCurrentItemIndex(index: Int) {
        currentItemIndex = index
        self.currentSubTitle = crateItems[currentItemIndex].song.title
    }
}
