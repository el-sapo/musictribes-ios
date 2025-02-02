//
//  CommunityHomeView.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 17/6/24.
//

import SwiftUI
import Combine

private struct UIConstants {
    static let frameBorder = 5.0
}

struct CommunityHomeView: View {
    @EnvironmentObject private var vmHome: HomeViewModel
    @StateObject private var vmCommunity: CommunityViewModel = CommunityViewModel(.mixtape)
    
    @State var description = ""
    @State private var showDescription: Bool = true
    
    let dataType: DataType = .mixtape

    private let pageHeight: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack() {
            if #available(iOS 18.0, *) {
                BackgroundMesh()
            } else {
                Color.black
            }
            Color.black
                .opacity(0.6)
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    // add gradient animation with orange to the logo
                    Spacer()
                        .frame(height: 20.0)
                    LogoView()
                        .frame(height: 50.0)
                        .padding(30.0)
                        .opacity(0.5)
                    VStack {
                        if !vmHome.loading {
                            Text(vmCommunity.title)
                                .customAttribute(EmphasisAttribute())
                                .myFont(style: .big, size: 32.0)
                                .scaledToFit()
                                .foregroundColor(.customCream)
                                .transition(TextTransition())
                                .animation(.default, value: !vmHome.loading)
                                .myAnimatedGlow(color: .white)
                                .padding(.top, 10.0)
                        }
                        VStack {
                            if vmCommunity.data.count > 0 {
                                CollectorItemCrateView(
                                    vmCrate: CrateViewModel(
                                        crateItems: vmCommunity.crateItems(),
                                        crateConfig: CrateViewConfig(
                                            showTextTop: false,
                                            showTextBottom: true,
                                            showCount: false,
                                            crateOffset: 20.0,
                                            maxItems: vmCommunity.data.count,
                                            color: .customOrange
                                        )
                                    )
                                )
                                CollectorItemCrateView()
                                    .environmentObject(CrateViewModel(
                                        crateItems: vmCommunity.crateItems(),
                                        crateConfig: CrateViewConfig(
                                            showTextTop: false,
                                            showTextBottom: true,
                                            showCount: false,
                                            crateOffset: 20.0,
                                            maxItems: vmCommunity.data.count,
                                            color: .customOrange
                                        )
                                    )
                                .frame(
                                    width: UIScreen.main.bounds.width - UIConstants.frameBorder * 4,
                                    height: UIScreen.main.bounds.width - UIConstants.frameBorder * 4
                                ).offset(CGSize(width: UIConstants.frameBorder, height: UIConstants.frameBorder))
                                    .padding(.trailing, UIConstants.frameBorder)
                                    .padding(.leading, UIConstants.frameBorder)
                                //.clipped()
                            }
                            Spacer()
                                .frame(height: 20.0)
                            if showDescription {
                                Text(description)
                                    .customAttribute(EmphasisAttribute())
                                    .myFont(style: .regular, size: 16.0)
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .transition(TextTransition())
                                    .padding(.leading, UIConstants.frameBorder)
                                    .padding(.trailing, UIConstants.frameBorder)
                                    .frame(height: 30.0)
                            } else {
                                Spacer()
                                    .frame(height: 30)
                            }
                            Spacer()
                                .frame(height: 10.0)
                        }
                        .frame(width: UIScreen.main.bounds.width - UIConstants.frameBorder * 2)
                        .padding(.all, 0.0)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.black) // Background color for the rounded rectangle
                                .shadow(radius: 10) // Optional: Add a shadow for better visual effect)
                        )
                        Spacer()
                            .frame(height: UIConstants.frameBorder / 2)
                    }
                    .frame(width: UIScreen.main.bounds.width - UIConstants.frameBorder) // Add padding to the entire ZStack
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(vmCommunity.itemColor) // Background color for the rounded rectangle
                            .shadow(radius: 10) // Optional: Add a shadow for better visual effect
                            .opacity(0.7)
                    )
                    Spacer()
                        .frame(height: 20)
                    ItemMenubar()
                        .frame(height: 40.0)
                    Spacer()
                }
                
            }.onReceive(vmCommunity.$currentItemIndex) { newValue in
                withAnimation {
                    self.description = vmCommunity.itemTitle
                    showDescription.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            showDescription.toggle()
                        }
                    }
                }
            }
            .contentMargins(.vertical, 44)
            .scrollTargetBehavior(.paging)
            VStack {
                Spacer()
                MusicPlayerView()
                    .opacity(0.0)
                Spacer()
                    .frame(height: 40.0)
            }
        }
    }
}

#Preview {
    CommunityHomeView()
        .environmentObject(HomeViewModel())
}



class CommunityViewModel: ObservableObject {
    @Published var title: String = "SCENES"
    @Published var currentItemIndex: Int = 0
    @Published var data: [CollectedArtist] = []
    @Published var colorCommunityHome: Color = .customOrange
    var communityType: DataType = .mixtape

    var cancellable: AnyCancellable?

    init() {
        loadDataforType()
    }

    init(artist: CollectedArtist) {
        title = artist.name
        data = artist.collectedItems.map({ collectedItem in
            CollectedArtist(contract: artist.contract,
                            name: artist.name,
                            collectedNumber: artist.collectedNumber,
                            collectedItems: [collectedItem]
            )
        })
        communityType = .artist
    }

    init(collectedArtists: [CollectedArtist]) {
        if collectedArtists.count > 1 {
            title = collectedArtists.first?.name ?? ""
        }
        data = collectedArtists
        communityType = .artist
    }

    init(_ dataType: DataType = .mixtape) {
        communityType = dataType
        switch dataType {
        case .mixtape:
            title = "DANC3 Mixtape I"
            colorCommunityHome = .customOrange
        case .scenes:
            title = "SCENES"
            colorCommunityHome = .scene1
        default:
            title = ""
            colorCommunityHome = .customGreen
        }
        loadDataforType(dataType)
    }

    func loadDataforType(_ dataType: DataType = .mixtape) {
        cancellable = DataManager.dataForType(dataType)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished loading JSON data.")
                case .failure(let error):
                    print("Error loading JSON data: \(error)")
                }
            }, receiveValue: { [weak self] collectedArtists in
                self?.data = collectedArtists
            })
    }
    
    var itemTitle: String {
        if data.count > currentItemIndex {
            return data[currentItemIndex].collectedItems[0].title
        } else {
            return ""
        }
    }

    var itemColor: Color {
        var color: Color = .customOrange
        guard communityType == .scenes else {
            return color
        }
        switch currentItemIndex {
        case 0:
            color = .scene1
        case 1:
            color = .scene2
        case 2:
            color = .scene3
        case 3:
            color = .scene4
        case 4:
            color = .scene5
        case 5:
            color = .scene6
        default:
            color = .customCream
        }
        return color
    }

    func extractCollectedItems() -> [CollectedItem] {
        return data.flatMap { $0.collectedItems }
    }

    func crateItems() -> [CrateItem] {
        return data.flatMap { artist in
            artist.collectedItems.map { song in
                CrateItem(artist: artist, song: song)
            }
        }
    }
}
