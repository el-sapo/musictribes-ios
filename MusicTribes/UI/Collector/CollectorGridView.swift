//
//  CollectorGridView.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 17/5/24.
//

import SwiftUI
import Combine

struct CollectorGridView: View {
    @StateObject var vmCollectorGrid: CollectorGridViewModel = CollectorGridViewModel()

    let columns: [GridItem] = [GridItem(.adaptive(minimum: 150, maximum: 300))]
    let communityColumns: [GridItem] = [GridItem(.adaptive(minimum: 150, maximum: 300))]
    let screenSize = UIScreen.main.bounds

//    let gridData: [CollectedArtist]
    let gridSeparation = 20.0

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {

                ScrollView {
                    ZStack(alignment: .top) {
                        ScrollingBackground()
                            .opacity(0.5)
                        Color.black
                            .opacity(0.4)
                        VStack {
                            Spacer().frame(height: 50.0)
                                .frame(maxWidth: .infinity)
                                .background(Color.customCream)
                            HStack {
                                LogoView(emboss: false)
                                    .frame(height: 30.0)
                                    .padding(.all, 5.0)
                                    .padding(.leading, 20.0)
                                    .shadow(radius: 10.0)
                                Spacer()
                                Image("pfp-pharos")
                                    .resizable()
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                                    .overlay(
                                        RoundedRectangle(cornerSize: CGSizeZero)
                                            .stroke(Color.customOrange, lineWidth: 1)
                                    )
                                    .rotationEffect(.degrees(20.0))
                                    .animation(.default, value: 20.0)
                                    .padding(.all, 3.0)
                                    .shadow(radius: 5.0, x: 3.0, y: 3.0)
                                Image("pfp-frog")
                                    .resizable()
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                                    .overlay(
                                        RoundedRectangle(cornerSize: CGSizeZero)
                                            .stroke(Color.customOrange, lineWidth: 1)
                                    )
                                    .rotationEffect(.degrees(-20.0))
                                    .animation(.default, value: 20.0)
                                    .padding(.all, 3.0)
                                    .shadow(radius: 5.0, x: 3.0, y: 3.0)
                                Image("pfp-raver-realm")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.customGreen)
                                    .aspectRatio(contentMode: .fit)
                                    .overlay(
                                        RoundedRectangle(cornerSize: CGSizeZero)
                                            .stroke(Color.customOrange, lineWidth: 1)
                                    )
                                    .rotationEffect(.degrees(20.0))
                                    .animation(.default, value: 20.0)
                                    .padding(.all, 3.0)
                                    .shadow(radius: 5.0, x: 3.0, y: 3.0)
                                Spacer()
                                Text("elsapo.eth")
                                    .myFont(style: .bold, size: 14.0)
                                    .scaledToFit()
                                    .foregroundColor(.customOrange)
                                    .myTribesGlow(color: .white)
                                    .padding(.trailing, 20.0)
                            }.background(Color.customCream)
                                .frame(height: 50.0)
                            Spacer()
                                .frame(height: 20.0)
                            // PFPs
                            HStack {

                            }
                            // COMMUNITIES
                            LazyVGrid(columns: columns, spacing: 20, pinnedViews: .sectionHeaders ,content: {
                                Section {
                                    ForEach(Array(vmCollectorGrid.communityData.enumerated()), id: \.offset) { index, community in
                                        CommunityCrateView(
                                            vmCrate: CrateViewModel(
                                                crateItems: community.crateItems()
                                            )
                                        )
                                        .frame(
                                            width: ((geometry.size.width / 2) - gridSeparation),
                                            height: geometry.size.width / 2 + 40.0
                                        )
                                    }
                                } header: {
                                    Text("Tribes")
                                        .myFont(style: .light, size: 30.0)
                                        .foregroundColor(.customCream)
                                        .padding(.all, 0.0)
                                        .shadow(radius: 10.0, x: 10.0, y: 10.0)
                                }
                            })
                            // COLLECTION
                            LazyVGrid(columns: columns, spacing: 20, pinnedViews: .sectionHeaders ,content: {
                                Section {
                                    ForEach(Array(vmCollectorGrid.collectionData.enumerated()), id: \.offset) { index, crate in
                                        CrateView(
                                            vmCrate: CrateViewModel(
                                                crateItems: crate.crateItems()
                                            )
                                        )
                                        .frame(
                                            width: ((geometry.size.width / 2) - gridSeparation),
                                            height: geometry.size.width / 2 + 40.0
                                        )
                                    }
                                } header: {
                                    Text("My Collection")
                                        .myFont(style: .light, size: 30.0)
                                        .foregroundColor(.customCream)
                                        .padding(.all, 0.0)
                                        .shadow(radius: 20.0)
                                }
                            })
                        }
                    }
                }
                .padding(.all, 0.0)
            }
        }
    }
}

#Preview {
    CollectorGridView()
}

struct Item: Identifiable {
    let id = UUID()
    let name: String
}

struct SectionData: Identifiable {
    let id = UUID()
    let title: String
    let items: [CollectedArtist]
}

class CollectorGridViewModel: ObservableObject {
    @Published var communityData: [Community] = []
    @Published var collectionData: [CollectedArtist] = []

    private var cancellables = Set<AnyCancellable>()

    init() {
        myCommunitiesData()
        myCollectionData()
    }

    func myCommunitiesData() {
        let danc3 = DataManager.dataForType(.mixtape)
        let scenes = DataManager.dataForType(.scenes)
        danc3.zip(scenes)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { _ in
            // hide loader
            } receiveValue: { [weak self] (danc3, scenes) in
                self?.communityData = [
                    Community(title: "DANC3", collectedItems: danc3),
                    Community(title: "SCENES", collectedItems: scenes)
                ]
            }
            .store(in: &cancellables)
    }

    func myCollectionData() {
        DataManager.dataForType(.artist)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { completion in

            } receiveValue: { [weak self] artists in
                self?.collectionData = artists
            }
            .store(in: &cancellables)
    }
}

