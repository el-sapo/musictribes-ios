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

    let gridSeparation = 20.0

    // animation:
    @State private var rotationAngle: Double = 0.0
    @State private var showCollectorSelector = false

    var body: some View {
        GeometryReader { geometry in


            VStack(alignment: .leading) {
                ScrollView {
                    ZStack(alignment: .top) {
                       ScrollingBackground()
                            .opacity(0.3)
                        Color.black
                            .opacity(0.8)
                            VStack {
                        Spacer().frame(height: 50.0)
                            .frame(maxWidth: .infinity)
                            .background(Color.customCream)
                        titleView
                        Spacer()
                            .frame(height: 20.0)
                        // COMMUNITIES
                        LazyVGrid(columns: columns, spacing: 20, pinnedViews: .sectionHeaders ,content: {
                            Section {
                                ForEach(Array(vmCollectorGrid.communityData.enumerated()), id: \.offset) { index, community in
                                    CommunityCrateView(
                                        vmCrate: CrateViewModel(
                                            crateItems: community.crateItems(),
                                            crateConfig: CrateViewConfig(color: .customOrange)
                                        )
                                    )
                                    .frame(
                                        width: ((geometry.size.width / 2) - gridSeparation),
                                        height: geometry.size.width / 2 + 40.0
                                    )
                                }
                            } header: {
                                Image("logo-tribes")
                                    .resizable()
                                    .aspectRatio(contentMode: ContentMode.fit)
                                    .foregroundColor(.customCream)
                                    .frame(height: 35.0)
                                    .opacity(0.8)
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
                                HStack(alignment: .top) {
                                    Spacer()
                                    Text("music")
                                        .myFont(style: .light, size: 25.0)
                                        .foregroundColor(.customCream)
                                        .padding(.all, 0.0)
                                        .shadow(radius: 10.0, x: 10.0, y: 10.0)
                                    Image("logo-pfp")
                                        .resizable()
                                        .aspectRatio(contentMode: ContentMode.fit)
                                        .foregroundColor(.customCream)
                                        .padding(.all, 0.0)
                                        .frame(height: 35.0)
                                        .opacity(0.8)
                                        .shadow(color: .black, radius: 10.0, x: 10.0, y: 10.0)
                                    Spacer()
                                }.padding(.top, 20)
                            }
                        })
                    }
                    }
                }.padding(.all, 0.0)
            }
        }
        .onAppear {
//            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
 //               rotationAngle = rotationAngle >= 0 ? -10.0 : 10.0
  //          }
        }
        .scrollBounceBehavior(.basedOnSize)
        .sheet(isPresented: $showCollectorSelector) {
            CollectorSelectorView()
                .transition(.move(edge: .bottom))
                .zIndex(1)
                .presentationDetents([.medium, .large])
                .environmentObject(vmCollectorGrid)
        }
        .fullScreenCover(isPresented: $vmCollectorGrid.isLoading) {
            LoaderView()
        }
    }

    @ViewBuilder
    private var titleView: some View {
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
                .rotationEffect(.degrees(20.0 + rotationAngle))
                .animation(.snappy, value: 20.0 + rotationAngle)
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
                .rotationEffect(.degrees(-5 + rotationAngle))
                .animation(.snappy, value: -5 + rotationAngle)
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
                .rotationEffect(.degrees(-rotationAngle))
                .animation(.snappy, value: -rotationAngle)
                .padding(.all, 3.0)
                .shadow(radius: 5.0, x: 3.0, y: 3.0)
            Spacer()
            Text(vmCollectorGrid.collectorName)
                .myFont(style: .bold, size: 14.0)
                .scaledToFit()
                .foregroundColor(.customOrange)
                .myTribesGlow(color: .white)
                .padding(.trailing, 20.0)
                .onTapGesture {
                    showCollectorSelector = true
                }
        }.background(Color.customCream)
            .frame(height: 50.0)
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
    @Published var isLoading = false
    @Published var collectorName: String = "elsapo.eth"

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

    func myCollectionData(_ collector: String = "elsapo.eth") {
        isLoading = true
        DataManager.shared.remoteDataForCollector(collector)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    print("Failed to fetch and map data: \(error.localizedDescription)")
                case .finished:
                    print("Data mapping finished.")
                }
            } receiveValue: { [weak self] artists in
                self?.collectionData = artists
                self?.collectorName = collector
            }
            .store(in: &cancellables)

/*
        DataManager.dataForType(.artist)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { completion in

            } receiveValue: { [weak self] artists in
                self?.collectionData = artists
            }
            .store(in: &cancellables)*/
    }
}

