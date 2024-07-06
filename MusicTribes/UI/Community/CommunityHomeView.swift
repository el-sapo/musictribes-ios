//
//  CommunityHomeView.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 17/6/24.
//

import SwiftUI
import Combine

struct CommunityHomeView: View {
    @EnvironmentObject private var vmHome: HomeViewModel
    @StateObject private var vmCommunity: CommunityViewModel = CommunityViewModel()
    
    @State var description = ""
    @State private var showDescription: Bool = true
    
    let dataType: DataType = .mixtape

    private let pageHeight: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack() {
            BackgroundMesh()
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
                    if !vmHome.loading {
                        Text(vmCommunity.title)
                            .customAttribute(EmphasisAttribute())
                            .myFont(style: .big, size: 32.0)
                            .scaledToFit()
                            .foregroundColor(.accent)
                            .transition(TextTransition())
                            .animation(.default, value: !vmHome.loading)
                    }
                    Spacer()
                        .frame(height: 20.0)
                    if vmCommunity.data.count > 0 {
                        CollectorItemCrateView(
                            collectorCrate: vmCommunity.data[0],
                            collectionCrateItems: vmCommunity.extractCollectedItems(),
                            crateConfig: CrateViewConfig(
                                showTextTop: false,
                                showTextBottom: true,
                                showCount: false,
                                crateOffset: 20.0,
                                maxItems: vmCommunity.data.count
                            )
                        )
                        .environmentObject(vmCommunity)
                        .frame(
                            width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.width
                        )
                        .clipped()
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
                            .padding(.leading, 30.0)
                            .padding(.trailing, 30.0)
                    } else {
                        Spacer()
                            .frame(height: 30)
                    }
                    Spacer()
                        .frame(height: 20)
                    ItemMenubar()
                        .frame(height: 40.0)
                    Spacer()
                }
                .frame(height: pageHeight)
                CommunityDetailView()
                    .frame(height: pageHeight)
                    .scrollTransition { content, phase in
                        content.opacity(phase.isIdentity ? 1.0 : 0.3 )
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
    @Published var title: String = "DANC3 Mixtape I"
    @Published var currentItemIndex: Int = 0
    @Published var data: [CollectedArtist] = []
    
    init() {
        loadDataforType()
    }
    
    var cancellable: AnyCancellable?
    //MockData.loadFromFile().first(where: { artist in
    //    return artist.name == "Sound of Fractures"
    //})!

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
    
    func extractCollectedItems() -> [CollectedItem] {
        return data.flatMap { $0.collectedItems }
    }
}
